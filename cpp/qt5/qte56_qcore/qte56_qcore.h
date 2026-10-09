#pragma once

// ─── Экспорт ──────────────────────────────────────────────────────────────────
#ifdef _WIN32
  #ifdef QTE56_QCORE_BUILD
    #define QCORE_API __declspec(dllexport)
  #else
    #define QCORE_API __declspec(dllimport)
  #endif
#else
  #define QCORE_API __attribute__((visibility("default")))
#endif

// ─── Типы QPointer (tp аргумент) ─────────────────────────────────────────────
// tp=1 : QPointer<eSlot>
// Каждая следующая DLL добавляет свои tp-числа в свои функции.
// QCore знает только о своих типах.

extern "C" {

// ── QPointer lifecycle (index 1-3) ────────────────────────────────────────────
// Выделяет пустой QPointer нужного типа. Возвращает void* на QPointer-объект.
QCORE_API void* qteQPointer_new(int tp);

// Удаляет QPointer-объект (не сам Qt-объект, только обёртку).
QCORE_API void  qteQPointer_delete(void* qptr, int tp);

// Возвращает true если Qt-объект внутри QPointer уже удалён.
QCORE_API bool  qteQPointer_isNull(void* qptr, int tp);

// ── eSlot (index 10-12) ───────────────────────────────────────────────────────
// Соединяет Qt сигнал со слотом по строковым именам (старый синтаксис SIGNAL/SLOT).
QCORE_API void  qteConnect(void* sender, const char* signal,
                            void* receiver, const char* slot, int conn_type);

// Создаёт объект eSlot, записывает в QPointer-обёртку qptr.
// parent — Qt-объект, который будет владельцем eSlot (обычно виджет).
// Возвращает сырой указатель на eSlot.
QCORE_API void* qteESlot_create(void* qptr, void* parent);

// Записывает D callback, dthis и тег n в eSlot.
QCORE_API void  qteESlot_set(void* slot, void* cb, void* dthis, int n);

// ── QString (index 20-22) ─────────────────────────────────────────────────────
// Создаёт heap-allocated QString из char16_t (D wstring совместим).
// Возвращает void* (QString*), освободить через qteQString_free.
QCORE_API void* qteQString_fromWStr(void* s, int len);

// Копирует содержимое QString в char16_t буфер buf длиной maxlen символов.
// Возвращает реальную длину строки (без нуль-терминатора).
QCORE_API int   qteQString_toWStr(void* qs, char16_t* buf, int maxlen);

// Освобождает heap-allocated QString.
QCORE_API void  qteQString_free(void* qs);

// ── Value types (index 30-38) ─────────────────────────────────────────────────
QCORE_API void* qteQRect_pack(int x, int y, int w, int h);
QCORE_API void  qteQRect_unpack(void* r, int* x, int* y, int* w, int* h);
QCORE_API void  qteQRect_free(void* r);

QCORE_API void* qteQPoint_pack(int x, int y);
QCORE_API void  qteQPoint_unpack(void* p, int* x, int* y);
QCORE_API void  qteQPoint_free(void* p);

QCORE_API void* qteQSize_pack(int w, int h);
QCORE_API void  qteQSize_unpack(void* s, int* w, int* h);
QCORE_API void  qteQSize_free(void* s);

// ── QApplication (index 50-55) ────────────────────────────────────────────────
// Создаёт QApplication. argc/argv берутся из внутреннего статического буфера.
// appName — имя приложения (char16_t*, может быть nullptr).
QCORE_API void* qteQApplication_create(void* appName);

// Запускает Qt event loop. Блокирует до выхода. Возвращает код завершения.
QCORE_API int   qteQApplication_exec(void* app);

// Просит Qt завершить event loop.
QCORE_API void  qteQApplication_quit(void* app);

// Обрабатывает накопившиеся события без блокировки.
QCORE_API void  qteQApplication_processEvents(void* app);

// Возвращает имя приложения как heap-allocated QString* (освободить qteQString_free).
QCORE_API void* qteQApplication_appName(void* app);

// Устанавливает имя приложения.
QCORE_API void  qteQApplication_setAppName(void* app, void* name);

// ── QApplication extended (index 56-71) ──────────────────────────────────────
// Устанавливает глобальный CSS-стиль приложения.
QCORE_API void  qteQApplication_setStyleSheet(void* app, void* css);

// Возвращает текущий CSS-стиль как QString* (освободить qteQString_free).
QCORE_API void* qteQApplication_styleSheet(void* app);

// Устанавливает стиль виджетов по имени ("Fusion", "Windows" и т.д.).
QCORE_API void  qteQApplication_setStyle(void* app, void* name);

// Возвращает имя текущего стиля как QString* (освободить qteQString_free).
QCORE_API void* qteQApplication_styleName(void* app);

// Устанавливает иконку приложения (void* = QIcon*).
QCORE_API void  qteQApplication_setWindowIcon(void* app, void* icon);

// Устанавливает override cursor по номеру Qt::CursorShape.
QCORE_API void  qteQApplication_setOverrideCursor(void* app, int shape);

// Восстанавливает cursor после setOverrideCursor.
QCORE_API void  qteQApplication_restoreOverrideCursor(void* app);

// Возвращает путь к директории приложения как QString*.
QCORE_API void* qteQApplication_appDirPath(void* app);

// Возвращает версию приложения как QString*.
QCORE_API void* qteQApplication_appVersion(void* app);

// Устанавливает версию приложения.
QCORE_API void  qteQApplication_setAppVersion(void* app, void* ver);

// Возвращает имя организации как QString*.
QCORE_API void* qteQApplication_orgName(void* app);

// Устанавливает имя организации.
QCORE_API void  qteQApplication_setOrgName(void* app, void* name);

// Системный звуковой сигнал.
QCORE_API void  qteQApplication_beep(void* app);

// Закрывает все окна верхнего уровня.
QCORE_API void  qteQApplication_closeAllWindows(void* app);

// Возвращает указатель на активное окно (QWidget*), или nullptr.
QCORE_API void* qteQApplication_activeWindow(void* app);

// Устанавливает шрифт приложения по умолчанию (void* = QFont*).
QCORE_API void  qteQApplication_setFont(void* app, void* font);

// Показывает стандартный диалог "About Qt".
QCORE_API void  qteQApplication_aboutQt(void* app);

// Возвращает шрифт приложения по умолчанию (new QFont*).
QCORE_API void* qteQApplication_font(void* app);

// Домен организации (используется QSettings, reversed DNS).
QCORE_API void* qteQApplication_orgDomain(void* app);
QCORE_API void  qteQApplication_setOrgDomain(void* app, void* domain);

// Полный путь к исполняемому файлу приложения.
QCORE_API void* qteQApplication_appFilePath(void* app);

// Текущее состояние модификаторов клавиатуры (Shift/Ctrl/Alt/Meta) как int
// (битовая маска Qt::KeyboardModifiers). Полезно в callback'ах event-handler'ов
// которые сами не получают modifiers (onWheel, onMousePress, и т.п.).
QCORE_API int qteQApplication_keyboardModifiers();

} // extern "C"
