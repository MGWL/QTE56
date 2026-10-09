#pragma once

// ── Экспорт символов ──────────────────────────────────────────────────────────
#ifdef _WIN32
#  ifdef QTE56_QCOMPLETER_BUILD
#    define COMPLETER_API __declspec(dllexport)
#  else
#    define COMPLETER_API __declspec(dllimport)
#  endif
#else
#  define COMPLETER_API __attribute__((visibility("default")))
#endif

extern "C" {

// ── QCompleter (20118–20131) ─────────────────────────────────────────────────
//
// Автодополнение для QLineEdit и QComboBox.
// Источник данных: строковый список (через разделитель \x01).
// Присоединяется к виджету через qteQLineEdit_setCompleter / qteQComboBox_setCompleter.
//
// Режимы (CompletionMode):
//   0 = PopupCompletion         — всплывающий список (по умолчанию)
//   1 = UnfilteredPopupCompletion — всплывающий без фильтрации
//   2 = InlineCompletion        — дополнение прямо в поле ввода
//
// Чувствительность к регистру:
//   0 = CaseInsensitive  (по умолчанию)
//   1 = CaseSensitive

// Создать пустой комплитер (без модели).
COMPLETER_API void* qteQCompleter_create();

// Создать комплитер из списка строк (строки объединены через \x01).
COMPLETER_API void* qteQCompleter_createList(const wchar_t* joined, int len);

// Удалить комплитер.
COMPLETER_API void  qteQCompleter_delete(void* c);

// Режим отображения дополнений (CompletionMode: 0/1/2).
COMPLETER_API void  qteQCompleter_setCompletionMode(void* c, int mode);

// Чувствительность к регистру (Qt::CaseSensitivity: 0=CI, 1=CS).
COMPLETER_API void  qteQCompleter_setCaseSensitivity(void* c, int cs);

// Максимальное число строк в выпадающем списке.
COMPLETER_API void  qteQCompleter_setMaxVisibleItems(void* c, int n);

// Задать префикс фильтрации (обычно устанавливается автоматически виджетом).
COMPLETER_API void  qteQCompleter_setPrefix(void* c, const wchar_t* prefix, int len);

// Число вариантов дополнения для текущего префикса.
COMPLETER_API int   qteQCompleter_completionCount(void* c);

// Текущий выбранный вариант дополнения.
// Возвращает новый QString* — освободить через qteQString_free.
COMPLETER_API void* qteQCompleter_currentCompletion(void* c);

// Показать всплывающий список принудительно.
COMPLETER_API void  qteQCompleter_complete(void* c);

// Заменить модель новым списком строк (строки объединены через \x01).
// Позволяет динамически обновлять варианты дополнения.
COMPLETER_API void  qteQCompleter_setModelFromList(void* c, const wchar_t* joined, int len);

// Сигнал activated(QString): cb(str, len, ctx) вызывается когда пользователь
// выбрал вариант дополнения из списка или нажал Enter.
COMPLETER_API void  qteQCompleter_connect_activated(void* c,
                        void (*cb)(const wchar_t*, int, void*), void* ctx);

// Присоединить комплитер к QLineEdit.
COMPLETER_API void  qteQLineEdit_setCompleter(void* lineEdit, void* completer);

// Присоединить комплитер к QComboBox.
COMPLETER_API void  qteQComboBox_setCompleter(void* comboBox, void* completer);

} // extern "C"
