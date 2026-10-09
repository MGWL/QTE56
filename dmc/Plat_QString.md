# План: полноценная работа с QString в QTE5-DMC

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [dmc/AGENTS.md](AGENTS.md)

## 1. Цель

Заменить упрощённые ASCII-заглушки `toQString`/`fromQString`/`freeQString` в `qte5dmc_core.h` на полноценную Unicode-работу через готовые DLL QTE56. Добавить удобный C++ API для `QString`, совместимый с DMC 8.42n (C++98), с использованием STLport 4.5.3 и только существующих DLL из `H:/qte56/arch_new/dll/dll32/`.

## 2. Ограничения и исходные данные

- **DLL QTE56 предоставляют только 3 функции для `QString`:**
  - `qteQString_fromWStr(void* s, int len)` — создаёт `QString*` из UTF-16 (индекс 20)
  - `qteQString_toWStr(void* qs, char16_t* buf, int maxlen)` — копирует `QString` в UTF-16 буфер (индекс 21)
  - `qteQString_free(void* qs)` — удаляет `QString*` (индекс 22)
- **DMC 8.42n:** C++98, нет `char16_t`, нет встроенной STL, нет `nullptr`.
- **STLport 4.5.3:** уже установлен в `c:\D\DMC\dm\stlport`.
  - Include-путь: `c:\D\DMC\dm\stlport\stlport`
  - Готовые библиотеки в `c:\D\DMC\dm\lib`:
    - `stlp45dm_static.lib` — статическая STLport без iostreams (рекомендуется)
    - `stlp45dms.lib` — static RTL + DLL STLport
    - другие debug/staticx/stldebug варианты
  - Для использования без iostreams: флаг `-D_STLP_NO_NEW_IOSTREAMS`.
- **Windows:** `wchar_t` = 2 байта (UTF-16), что совпадает с ожиданиями DLL и с `std::wstring`.
- **QByteArray DLL** (`qte56_foundation.dll`) даёт байтовые операции (`mid`, `left`, `right`, `toUpper`, `toLower`, `trimmed`), но они корректны только для ASCII.
- Перекомпиляция DLL **не требуется** и не планируется.

## 3. Рекомендуемый подход

### 3.0 Подключение STLport 4.5.3

Использовать STLport **без iostreams** (только контейнеры и строки), чтобы не тянуть лишние зависимости и DLL runtime.

В `build.bat` добавить:

```bat
set STLPORT_INCLUDE=c:\D\DMC\dm\stlport\stlport
set STLPORT_LIB=c:\D\DMC\dm\lib\stlp45dm_static.lib

set DMCFLAGS=-I%STLPORT_INCLUDE% -D_STLP_NO_NEW_IOSTREAMS
set LINKLIBS=user32+kernel32+%STLPORT_LIB%/noi
```

При компиляции каждого `.cpp`:

```bat
dmc -c %DMCFLAGS% file.cpp -ofile.obj
```

При линковке:

```bat
dmc file.obj %OBJS% -oout.exe,,user32+kernel32+%STLPORT_LIB%/noi;
```

STLport позволяет:
- Хранить UTF-8 строки в `std::string` — `length()`, `append()`, `substr()`, `find()` и т.д.
- Хранить UTF-16 данные в `std::wstring` — `wchar_t` в DMC/Windows = 2 байта, что совпадает с `QChar`.
- Динамически выделять буферы через `std::vector<wchar_t>` без ручного `new/delete`.
- Упростить реализацию `QStringDMC`: внутри остаётся `void* _qs` (указатель на `QString*` в DLL), но все конвертации и локальные операции делаются через `std::string`/`std::wstring`.

### 3.1 Базовый слой: Unicode-хелперы в `qte5dmc_core.h`

Заменить inline `toQString`/`fromQString`/`freeQString` на реальные вызовы `pFunQt[20..22]` с конвертацией UTF-8 ↔ UTF-16 через WinAPI и STLport:

```cpp
typedef unsigned short char16_t;   // DMC не знает char16_t

typedef void* (*t_qs_fromwstr)(void*, int);
typedef int   (*t_qs_towstr)(void*, char16_t*, int);
typedef void  (*t_qs_free)(void*);

void* toQString(const char* utf8);             // UTF-8 → QString*
int   fromQString(void* qs, char* buf, int n); // QString* → UTF-8
void  freeQString(void* qs);                   // delete QString*
```

Внутри `toQString`:
1. `MultiByteToWideChar(CP_UTF8, ...)` — узнать нужный размер UTF-16.
2. `std::vector<wchar_t> wbuf(size);`
3. `MultiByteToWideChar(...)` — заполнить `wbuf`.
4. Вызвать `qteQString_fromWStr(wbuf.data(), len)`.

Внутри `fromQString`:
1. `std::vector<wchar_t> wbuf(maxlen);`
2. `qteQString_toWStr(qs, wbuf.data(), maxlen)` — получить UTF-16.
3. `WideCharToMultiByte(CP_UTF8, ...)` — UTF-16 → UTF-8 в пользовательский `buf`.

### 3.2 Класс `QStringDMC`

Создать `qte5dmc_qstring.h` / `qte5dmc_qstring.cpp` (или `gen/gen_qstring.h/cpp`). Использовать STLport для внутренних буферов:

- **Хранение:** `void* _qs` — указатель на `QString*` в DLL.
- **Внутренние буферы:** `std::string` для UTF-8, `std::wstring` для UTF-16.
- **Конструкторы:**
  - из `const char*` (UTF-8)
  - из `const wchar_t*` (UTF-16)
  - из `const std::string&` (UTF-8)
  - из `const std::wstring&` (UTF-16)
  - из `void*` (существующий `QString*` из DLL)
  - копирующий конструктор
- **Операторы:** `=`, `+=`, `==`, `!=`, `+`.
- **Методы:**
  - `isEmpty()`, `size()`, `length()`
  - `std::string toUtf8()` — получить UTF-8 как `std::string`
  - `std::wstring toWString()` — получить UTF-16 как `std::wstring`
  - `int toUtf8(char* buf, int n)` — для совместимости с C API
  - `const char* toLocal8Bit(char* buf, int n)` — для консоли (OEM/ANSI)
  - `append`, `prepend`, `mid`, `left`, `right` — локальная реализация через `std::string`
  - `indexOf`, `contains`, `startsWith`, `endsWith` — через `std::string::find`
  - `toUpper`, `toLower`, `trimmed`, `simplified` — через `QByteArray` DLL (только ASCII) или локально
  - `std::vector<QStringDMC> split(const char* sep)` — через `std::string::find`
  - `static QStringDMC join(const QStringDMC* parts, int count, const char* sep)`
  - `static QStringDMC number(int v)`, `number(double v)`
  - `QStringDMC arg(const QStringDMC& a)` — упрощённая замена `%1`
  - `void* raw()` — получить `void*` для передачи в Qt-функции
  - `static QStringDMC fromRaw(void* qs, bool takeOwnership = true)` — обёртка над `QString*` из DLL

### 3.3 Интеграция с виджетами

Добавить в `gen_*` классы перегруженные методы, принимающие/возвращающие `QStringDMC`:

```cpp
void QLabel::setText(const QStringDMC& s);
QStringDMC QLabel::text() const;
```

Старый `const char*` интерфейс можно сохранить для обратной совместимости — внутри он будет создавать `QStringDMC`.

## 4. Этапы реализации

### Этап 0. Подготовка и проверка STLport
- Проверить, что `pFunQt[20]`, `pFunQt[21]`, `pFunQt[22]` загружаются корректно.
- Проверить размер `wchar_t` в DMC (`sizeof(wchar_t) == 2`).
- Скомпилировать smoke-test `c:\D\DMC\dm\stlport\hello.cpp`:
  ```bat
  dmc c:\D\DMC\dm\stlport\hello.cpp -Ic:\D\DMC\dm\stlport\stlport -D_STLP_NO_NEW_IOSTREAMS
  hello.exe
  ```
- Скомпилировать детальную тестовую программу `test_stlport.cpp` с проверкой всех возможностей `std::string`, `std::wstring`, `std::vector`, `std::list`, `std::map` и UTF-8 ↔ UTF-16 конвертации:

  ```cpp
  #include <stdio.h>
  #include <string>
  #include <vector>
  #include <list>
  #include <map>
  #include <windows.h>

  static int g_fail = 0;
  #define CHECK(cond, msg) if (!(cond)) { printf("FAIL: %s\n", msg); g_fail++; } else printf("OK: %s\n", msg)

  int main() {
      printf("=== STLport 4.5.3 comprehensive test ===\n");

      // 1. std::string basics
      std::string s1 = "Hello";
      std::string s2("DMC");
      std::string s3 = s1;
      CHECK(s1.length() == 5, "std::string length");
      CHECK(s1.size() == 5, "std::string size");
      CHECK(!s1.empty(), "std::string not empty");
      CHECK(s1 == s3, "std::string equality");
      CHECK(s1 != s2, "std::string inequality");
      CHECK(s1 < s2, "std::string less");

      // 2. std::string concatenation and modification
      s1 += " ";
      s1.append(s2);
      CHECK(s1 == "Hello DMC", "std::string append");
      s1.insert(5, ",");
      CHECK(s1 == "Hello, DMC", "std::string insert");
      s1.replace(0, 5, "Hi");
      CHECK(s1 == "Hi, DMC", "std::string replace");
      s1.erase(2, 1);
      CHECK(s1 == "Hi DMC", "std::string erase");
      s1 += "!";
      CHECK(s1 == "Hi DMC!", "std::string += char");

      // 3. std::string search and substring
      size_t pos = s1.find("DMC");
      CHECK(pos == 3, "std::string find");
      pos = s1.find('M');
      CHECK(pos == 4, "std::string find char");
      pos = s1.rfind('!');
      CHECK(pos == 6, "std::string rfind");
      std::string sub = s1.substr(3, 3);
      CHECK(sub == "DMC", "std::string substr");
      CHECK(s1.compare("Hi DMC!") == 0, "std::string compare");
      CHECK(s1.find("XYZ") == std::string::npos, "std::string npos");

      // 4. std::string c_str and clearing
      const char* c = s1.c_str();
      CHECK(c[0] == 'H', "std::string c_str");
      s1.clear();
      CHECK(s1.empty(), "std::string clear");

      // 5. std::wstring basics
      std::wstring w1 = L"Привет";
      std::wstring w2(L"DMC");
      std::wstring w3 = w1;
      CHECK(w1.length() == 6, "std::wstring length (Russian)");
      CHECK(w1 == w3, "std::wstring equality");
      CHECK(w1 != w2, "std::wstring inequality");
      w1 += L" ";
      w1.append(w2);
      CHECK(w1.length() == 10, "std::wstring append (Russian)");
      size_t wpos = w1.find(L"DMC");
      CHECK(wpos == 7, "std::wstring find");
      std::wstring wsub = w1.substr(0, 6);
      CHECK(wsub == L"Привет", "std::wstring substr (Russian)");
      const wchar_t* wc = w1.c_str();
      CHECK(wc[0] == L'П', "std::wstring c_str (Russian)");
      CHECK(sizeof(wchar_t) == 2, "sizeof(wchar_t) == 2");

      // 6. std::vector
      std::vector<char> v1;
      v1.push_back('A');
      v1.push_back('B');
      v1.push_back('C');
      CHECK(v1.size() == 3, "std::vector char size");
      CHECK(v1[0] == 'A' && v1[1] == 'B' && v1[2] == 'C', "std::vector char access");
      v1.resize(5);
      CHECK(v1.size() == 5, "std::vector char resize");

      std::vector<wchar_t> v2;
      v2.push_back(L'П');
      v2.push_back(L'р');
      v2.push_back(L'и');
      CHECK(v2.size() == 3, "std::vector wchar_t size");
      CHECK(v2[0] == L'П', "std::vector wchar_t access");
      v2.resize(10);
      CHECK(v2.size() == 10, "std::vector wchar_t resize");

      // 7. std::list and std::map
      std::list<int> lst;
      lst.push_back(1);
      lst.push_back(2);
      lst.push_front(0);
      CHECK(lst.size() == 3, "std::list size");

      std::map<std::string, int> mp;
      mp["one"] = 1;
      mp["two"] = 2;
      CHECK(mp["one"] == 1, "std::map string key");
      CHECK(mp["two"] == 2, "std::map string key 2");

      // 8. UTF-8 ↔ UTF-16 conversion via WinAPI
      const char* utf8 = "Привет, DMC!";
      int wlen = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
      CHECK(wlen > 0, "MultiByteToWideChar size");
      std::vector<wchar_t> wbuf(wlen);
      int ret = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, wbuf.data(), wlen);
      CHECK(ret == wlen, "MultiByteToWideChar convert");

      int ulen = WideCharToMultiByte(CP_UTF8, 0, wbuf.data(), wlen - 1, NULL, 0, NULL, NULL);
      CHECK(ulen > 0, "WideCharToMultiByte size");
      std::vector<char> ubuf(ulen + 1);
      ret = WideCharToMultiByte(CP_UTF8, 0, wbuf.data(), wlen - 1, ubuf.data(), ulen, NULL, NULL);
      CHECK(ret == ulen, "WideCharToMultiByte convert");
      ubuf[ulen] = '\0';
      CHECK(strcmp(ubuf.data(), utf8) == 0, "UTF-8 roundtrip");

      // 9. Emoji / surrogate pairs
      const char* emoji = "Hello \xF0\x9F\x98\x80";
      int elen = MultiByteToWideChar(CP_UTF8, 0, emoji, -1, NULL, 0);
      CHECK(elen > 0, "MultiByteToWideChar emoji size");
      std::vector<wchar_t> ebuf(elen);
      MultiByteToWideChar(CP_UTF8, 0, emoji, -1, ebuf.data(), elen);
      CHECK(ebuf[6] == 0xD83D && ebuf[7] == 0xDE00, "UTF-16 surrogate pair");

      if (g_fail == 0) {
          printf("=== STLport test PASSED ===\n");
          return 0;
      } else {
          printf("=== STLport test FAILED (%d failures) ===\n", g_fail);
          return 1;
      }
  }
  ```

  ```bat
  dmc test_stlport.cpp -Ic:\D\DMC\dm\stlport\stlport -D_STLP_NO_NEW_IOSTREAMS c:\D\DMC\dm\lib\stlp45dm_static.lib
  test_stlport.exe
  ```

- Если всё работает — добавить STLport include/lib в `build.bat`.
- Создать `test/test_qstring_core.cpp` — базовый roundtrip UTF-8 ↔ QString*.

### Этап 1. Unicode-хелперы
- Заменить `toQString`/`fromQString`/`freeQString` в `qte5dmc_core.h`.
- Добавить `typedef` для `char16_t` и typedef-ы для функций `pFunQt[20..22]`.
- Использовать `std::vector<wchar_t>` для динамических UTF-16 буферов.
- Обновить `test_qcore.cpp` и `test_minimal.cpp` для проверки русского текста.
- Убедиться, что все существующие тесты продолжают проходить.

### Этап 2. Класс `QStringDMC`
- Создать `qte5dmc_qstring.h` / `qte5dmc_qstring.cpp`.
- Реализовать конструкторы, деструктор, присваивание, `raw()`, `fromRaw()`.
- Реализовать `toUtf8()`, `toWString()`, `isEmpty()`, `size`.
- Написать `test/test_qstring_class.cpp`.

### Этап 3. Операции со строками
- Локальные UTF-8 через `std::string`: `append`, `prepend`, `mid`, `left`, `right`, `indexOf`, `contains`, `startsWith`, `endsWith`.
- `split`, `join`, `arg`, `number` через `std::string`.
- Через `QByteArray` DLL: `toUpper`, `toLower`, `trimmed` (с документированием ASCII-ограничения).
- Расширить `test/test_qstring_class.cpp`.

### Этап 4. Интеграция с виджетами
- Обновить `gen_qlabel.h/cpp`, `gen_qlineedit.h/cpp`, `gen_qabstractbutton.h/cpp` и др. — добавить `QStringDMC` API.
- Обновить `test_gui.cpp`: заменить `const char*` подписи на русский текст.
- Проверить `QMessageBox`, `QFileDialog`, `QInputDialog` с Unicode.

### Этап 5. Тестирование и документация
- Создать `test/test_qstring_full.cpp` с комплексными проверками.
- Обновить `build.bat` — добавить `qte5dmc_qstring.cpp`, STLport include/lib и флаг `-D_STLP_NO_NEW_IOSTREAMS`.
- Обновить `QTE5DMC_GUIDE.md` раздел про строки.
- Сохранить итоговый план/результат в `Plat_QString.md` в папке проекта.

## 5. Риски и митигация

| Риск | Митигация |
|------|-----------|
| DMC не знает `char16_t` | `typedef unsigned short char16_t;` |
| Суррогатные пары UTF-16 | WinAPI корректно обрабатывает; локальные UTF-8 операции работают с байтами, не code points |
| Ограниченность DLL (только 3 функции) | Локальная реализация операций на UTF-8 + документирование ограничений |
| Регресс существующих тестов | Сохранить `const char*` API, внутри конвертировать в `QStringDMC` |
| Буфер недостаточного размера | `std::vector<wchar_t>` для динамических буферов |
| STLport не линкуется | Проверить `hello.cpp` и `test_stlport.cpp` перед началом |
| STLport iostreams конфликтуют с DMC | Использовать `-D_STLP_NO_NEW_IOSTREAMS` |

## 6. Критерии завершения

1. `c:\D\DMC\dm\stlport\hello.cpp` и тест `test_stlport.cpp` успешно компилируются и запускаются.
2. `test_qcore.cpp` проходит roundtrip с русским текстом.
3. `test_qstring_full.cpp` проходит.
4. `test_gui.cpp` корректно отображает русские подписи виджетов.
5. Все существующие тесты (`test_minimal`, `test_qbytearray`, `test_qdate`, `test_qsize`, `test_qwidgets`, `test_dialogs`) продолжают проходить.
6. Документация `QTE5DMC_GUIDE.md` обновлена.
