# QTE56 — AI_TEXTEDITOR (QTextEdit, QPlainTextEdit, QTextBrowser, QScintilla)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_text.dll (QTextEdit/Plain/Browser) + qte56_qscintilla.dll + qscintilla2_qt5.dll

---

## QTextEdit — форматированный текст (HTML)

```d
// import: gen_qtextedit
auto te = new QTextEdit(cast(void*)null);

// Содержимое:
te.setPlainText("Line 1\nLine 2\nLine 3");
te.setHtml("<h2>Title</h2><p>Body <b>bold</b> <i>italic</i></p>");
string plain = te.toPlainText();
string html  = te.toHtml();
te.append("New line at bottom");
te.clear();
te.setPlaceholderText("Enter text here...");

// Режим:
te.setReadOnly(true);
te.setAcceptRichText(false);     // только plain text
te.setLineWrapMode(1);           // 1=WidgetWidth 0=NoWrap 2=FixedPixelWidth 3=FixedColumnWidth
te.setLineWrapColumnOrWidth(80);
te.setTabStopDistance(32.0);     // ширина Tab в пикселях
te.setOverwriteMode(false);

// Шрифт (current char format в позиции курсора):
te.setFontFamily("Courier New");
te.setFontPointSize(12.0);
te.setFontWeight(75);            // 75=Bold, 50=Normal
te.setFontItalic(true);
te.setFontUnderline(true);
te.setAlignment(0x4);            // AlignHCenter

// Курсор:
te.moveCursor(11, 0);            // 11=MoveToEnd 1=MoveLeft 2=MoveRight 3=MoveUp 4=MoveDown
                                  // mode: 0=MoveAnchor 1=KeepAnchor (выделить)
te.moveCursor(1, 1);             // выделить 1 символ влево
te.ensureCursorVisible();

// Поиск:
bool found = te.find("word", 0); // options: 0=normal 1=BackwardSearch 2=CaseSensitive 4=WholeWords
te.find("word", 3);              // case-sensitive (2|1) backwards

// Clipboard:
bool canP = te.canPaste();

// Undo/Redo:
te.undo(); te.redo();

// Строки/позиция:
te.setLines(["line1", "line2"]); // заменить всё

// Сигналы (ESlot, invoke_v — без параметров):
__gshared ESlot g_slChanged;
extern(C) void onTextChanged(void* dt, int n) { }  // без параметров!
g_slChanged = new ESlot(te.getWH()); g_slChanged.set(cast(void*)&onTextChanged);
te.connect_textChanged(g_slChanged);

// Другие сигналы (invoke_v):
// connect_selectionChanged, connect_cursorPositionChanged
// Сигналы (invoke_b):
// connect_undoAvailable, connect_redoAvailable, connect_copyAvailable
```

---

## QPlainTextEdit — простой текст (эффективный для лог-вывода)

```d
// import: gen_qplaintextedit
auto pte = new QPlainTextEdit(cast(void*)null);

// Содержимое:
pte.setPlainText("Log output\nLine 2");
string txt = pte.toPlainText();
pte.appendPlainText("New line");      // добавить строку (без HTML)
pte.appendHtml("<b>bold</b>");        // HTML тоже поддерживается
pte.clear();
pte.setPlaceholderText("Output...");

// Режим:
pte.setReadOnly(true);
pte.setLineWrapMode(1);              // 1=WidgetWidth, 0=NoWrap
pte.setMaximumBlockCount(1000);      // ограничить кол-во строк (лог)
pte.setTabStopDistance(32.0);

// Прокрутка к концу (для лога):
pte.ensureCursorVisible();
pte.moveCursor(11, 0);               // 11=MoveToEnd — затем ensureCursorVisible

// Количество строк:
int lineCount = pte.blockCount();    // количество блоков (строк)

// Поиск:
bool found = pte.find("text", 2);    // 2=CaseSensitive

// Типичный паттерн лог-вывода:
extern(C) void appendLog(string line) {
    pte.appendPlainText(line);
    pte.moveCursor(11, 0);      // MoveToEnd
    pte.ensureCursorVisible();
}

// Сигналы (ESlot, invoke_v):
// connect_textChanged, connect_selectionChanged, connect_cursorPositionChanged
// (invoke_i): connect_blockCountChanged
// (invoke_b): connect_undoAvailable, connect_redoAvailable, connect_copyAvailable
```

---

## QTextBrowser — HTML-просмотрщик с навигацией

```d
// import: gen_qtextbrowser (наследует QTextEdit)
auto tb = new QTextBrowser(cast(void*)null);

// Содержимое:
tb.setHtml("<h1>Title</h1><p>Text with <a href='page2'>link</a></p>");
tb.setPlainText("Plain text");
// Загрузить файл:
tb.setSource("help.html");           // или путь к файлу

// Навигация:
tb.backward();    // назад в истории
tb.forward();     // вперёд
tb.home();        // в начало
bool canBack = tb.isBackwardAvailable();
bool canFwd  = tb.isForwardAvailable();

// Открытие внешних ссылок:
tb.setOpenExternalLinks(true);
tb.setOpenLinks(false);              // false = обрабатывать самому

// Клик по ссылке:
extern(C) void onLink(void* dt, int n, void* urlPtr) {
    // urlPtr — QUrl; используем fromQString для текста
    // Лучше: tb.anchorAt(pos) в onMousePress
}
tb.connect_anchorClicked(cast(void*)&onLink, null);

// Поиск (наследовано от QTextEdit):
tb.find("text", 2);                  // 2=CaseSensitive
```

---

## QScintilla — профессиональный редактор кода

```d
// import: gen_qscintilla
// КРИТИЧНО: нужны ОБА DLL в PATH:
//   qte56_qscintilla.dll + qscintilla2_qt5.dll
// LoadQt("./dll") — обе DLL должны быть в ./dll/

auto sci = new QsciScintilla(cast(void*)null);

// ── Содержимое ────────────────────────────────────────────────────────────
sci.setText("void main() {\n    writeln(\"Hello\");\n}");
string txt   = sci.text();
sci.setText("");                     // очистить (НЕ clearAll!)
sci.append("// Comment\n");
int    lines = sci.lines();
int    len   = sci.length();

// ── Нумерация строк ───────────────────────────────────────────────────────
sci.setMarginWidth(0, 40);           // ширина margin 0 под номера строк
sci.setMarginWidth(0, 0);            // убрать нумерацию

// ── Подсветка синтаксиса ─────────────────────────────────────────────────
void* lex = QsciScintilla.createLexerCPP();    // C/C++
// void* lex = QsciScintilla.createLexerPython();
// void* lex = QsciScintilla.createLexerD();
// void* lex = QsciScintilla.createLexerSQL();
// void* lex = QsciScintilla.createLexerJSON();
// void* lex = QsciScintilla.createLexerBash();
// void* lex = QsciScintilla.createLexerBatch();

// Настроить шрифт лексера:
auto font = new QFont("Courier New"); font.setPointSize(11);
QsciScintilla.lexerSetDefaultFont(lex, font.getWH());
QsciScintilla.lexerSetDefaultPaper(lex, 0xFF_1E1E1E); // тёмный фон ARGB
QsciScintilla.lexerSetDefaultColor(lex, 0xFF_D4D4D4); // светлый текст

// Установить лексер:
sci.setLexer(lex);
// QsciScintilla.deleteLexer(lex); — НЕ удалять! sci берёт ownership

// ── Code folding ──────────────────────────────────────────────────────────
sci.setFolding(5);                   // 5=BoxedTreeFoldStyle (отступы+рамки)
// 0=NoFoldStyle 1=PlainFoldStyle 2=CircledFoldStyle 3=BoxedFoldStyle
// 4=CircledTreeFoldStyle 5=BoxedTreeFoldStyle

// ── Отступы ───────────────────────────────────────────────────────────────
sci.setIndentationsUseTabs(false);   // использовать пробелы
sci.setIndentationWidth(4);
sci.setTabWidth(4);
sci.setAutoIndent(true);
sci.setUtf8(true);

// ── Подсветка скобок ─────────────────────────────────────────────────────
sci.setBraceMatching(2);             // 0=None 1=SloppyMatch 2=StrictMatch

// ── Подсветка текущей строки ─────────────────────────────────────────────
sci.setCaretLineVisible(true);
sci.setCaretLineBackgroundColor(0x20_000080); // ARGB полупрозрачный

// ── Поля (margins) ───────────────────────────────────────────────────────
sci.setMarginsBackgroundColor(0xFF_2D2D2D);
sci.setMarginsForegroundColor(0xFF_858585);

// ── EOL ──────────────────────────────────────────────────────────────────
sci.setEolMode(0);                   // 0=CRLF 1=CR 2=LF

// ── Поиск ─────────────────────────────────────────────────────────────────
bool found = sci.findFirst("text",
    false,  // regexp
    false,  // caseSensitive
    false,  // wholeWord
    true,   // wrap (с начала)
    true,   // forward
    -1, -1  // line, col (-1 = с текущей позиции)
);
// Следующее совпадение:
sci.findNext();

// ── Автодополнение ───────────────────────────────────────────────────────
sci.setAutoCompletionSource(1);      // 1=AcsAll (из лексера + пользователя)
sci.setAutoCompletionThreshold(2);   // начать после 2 символов

// ── Только чтение ─────────────────────────────────────────────────────────
sci.setReadOnly(true);

// ── Шрифт (без лексера) ───────────────────────────────────────────────────
auto f = new QFont("Courier New"); f.setPointSize(11);
sci.setEditorFont(f.getWH());

// Сигналы (прямые, не ESlot):
// Нет connect_textChanged — отслеживать через QTextEdit parent API
```

---

## QFont — настройка шрифтов

```d
// import: gen_qfont
auto f = new QFont("Arial");         // по имени семейства
auto f = new QFont("Courier New");   // моноширинный

f.setPointSize(12);
f.setPixelSize(16);                  // альтернатива setPointSize
f.setBold(true);
f.setItalic(true);
f.setUnderline(true);
f.setStrikeOut(true);
f.setWeight(75);                     // 25=Light 50=Normal 75=Bold
f.setFamily("Segoe UI");
f.setFixedPitch(true);               // использовать только моноширинные

// Применить:
widget.setFont(f);
te.setFont(f);
// sci.setEditorFont(f.getWH());     // для QScintilla

// Получить текущий шрифт виджета:
void* fontWH = widget.font();
auto f2 = QFont.wrap(fontWH);
```

---

## QSyntaxHighlighter — подсветка для QTextEdit

```d
// import: gen_qsyntaxhighlighter + gen_qtextdocument
// Используется для QTextEdit/QPlainTextEdit (НЕ для QScintilla)

// QTE56 предоставляет базовый highlighter
// Для кастомных правил — реализовать в C++ и экспортировать
// Типичное использование: встроенные лексеры QScintilla для кода.
// Для простой подсветки в QTextEdit — ручной QTextCursor + QTextCharFormat

// Пример подсветки ключевых слов вручную:
// QTextDocument.find() в QTE56 не забинден (document() возвращает void*),
// поэтому ручная подсветка через QTextCursor недоступна —
// для кода используйте встроенные лексеры QScintilla.
```

---

## Типовой паттерн: текстовый редактор с файлом

```d
__gshared QPlainTextEdit g_editor;
__gshared string         g_currentFile;
__gshared bool           g_modified = false;

// Заголовок с именем файла:
void updateTitle() {
    string name = g_currentFile.length > 0 ? g_currentFile : "untitled";
    g_win.setWindowTitle((g_modified ? "* " : "") ~ name ~ " — MyEditor");
}

// Открыть файл:
void openFile(string path) {
    import std.file : readText;
    try {
        g_editor.setPlainText(readText(path));
        g_currentFile = path;
        g_modified = false;
        updateTitle();
    } catch (Exception e) {
        QMessageBox.critical(g_win.getWH(), "Error", e.msg);
    }
}

// Сохранить:
void saveFile(string path) {
    import std.file : write;
    try {
        write(path, g_editor.toPlainText());
        g_currentFile = path;
        g_modified = false;
        updateTitle();
    } catch (Exception e) {
        QMessageBox.critical(g_win.getWH(), "Error", e.msg);
    }
}

// Отслеживать изменения:
__gshared ESlot g_slMod;
extern(C) void onModified(void* dt, int n) {
    g_modified = true;
    updateTitle();
}
g_slMod = new ESlot(g_editor.getWH()); g_slMod.set(cast(void*)&onModified);
g_editor.connect_textChanged(g_slMod);

// Защита от закрытия с несохранёнными данными:
extern(C) void onClose(void* dt, int* accept) {
    if (!g_modified) { *accept = 1; return; }
    int r = QMessageBox.question(g_win.getWH(), "Save?",
        "Save changes?",
        QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel,
        QMessageBox.Cancel);
    if (r == QMessageBox.Yes)    { saveFile(g_currentFile); *accept = 1; }
    else if (r == QMessageBox.No){ *accept = 1; }
    else                         { *accept = 0; }
}
g_win.onClose(cast(void*)&onClose);
```

---

## Gotchas

```
1. QScintilla: ОБА DLL обязательны — qte56_qscintilla.dll + qscintilla2_qt5.dll.
2. QScintilla очистить: setText("") — метода clearAll() НЕТ.
3. setLexer(lex) — sci берёт ownership. НЕ вызывать deleteLexer после!
4. QTextEdit.connect_textChanged — invoke_v (нет параметров!), не invoke_s.
5. QPlainTextEdit.appendPlainText — добавляет без HTML-парсинга (быстро для логов).
6. QPlainTextEdit.setMaximumBlockCount(N) — ограничить размер лога.
7. QScintilla в MdiSubWindow: при закрытии краш!
   Решение: subwindow.onClose → sci.setParent(null) перед *accept=1.
8. QFont создавать через new — не static. wrap() для полученных от виджетов.
9. QTextEdit.find() — возвращает bool, НЕ QTextCursor как в Qt C++ API.
10. QsciScintilla.lines() — количество СТРОК (не блоков как в QPlainTextEdit).
```
