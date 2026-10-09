//------------------------------
// qtforth.d - демо: GUI на QtE56, логика на forthD
//   Окно: QLabel + QPushButton. Клик -> D-слот (легальный контекст) ->
//   evalForth("1 COUNTER +! UPDATE-LABEL") -> Форт строит строку и через
//   шим fw_setText (общая таблица, ячейка 30) меняет текст QLabel.
//   Весь цикл Qt->D->Форт->Qt без моста: колбэки в D, Форт - в evalForth.
// Сборка (из корня arch_new):
//   dmd -m32 forth/forth.d forth/qtforth.d d/qte56_core.d d/qte56_loader.d ^
//     d/gen/gen_qcore.d d/gen/gen_qobject.d d/gen/gen_qfont.d d/gen/gen_qwidget.d ^
//     d/gen/gen_qlabel.d d/gen/gen_qlayout.d d/gen/gen_qabstractbutton.d ^
//     d/gen/gen_qpushbutton.d -Id -Id/gen -of=forth/qtforth.exe
// Запуск: из корня arch_new (путь ./dll/dll32), PATH должен видеть Qt5 (bin513).
//------------------------------
import std.stdio : writeln, write, File;
import std.file : exists;
import std.string : fromStringz;
import std.conv : to;

import qte56_core;       // pFunQt
import qte56_loader;     // LoadQt()
import gen_qcore;        // QApplication, ESlot, connectQt
import gen_qwidget;      // QWidget
import gen_qlabel;       // QLabel
import gen_qpushbutton;  // QPushButton
import gen_qlayout;      // QVBoxLayout
import forth;            // ядро forthD

// dmd -m32 -release -i qtforth.d forth.d -I..\d -I..\d\gen

__gshared QApplication g_app;
__gshared QLabel g_lbl;

// --- ШИМ ДЛЯ ФОРТА (ячейка 30 общей таблицы): QLabel.setText из Форта ---
export extern(C) void fw_setText(char* ztext) {
    g_lbl.setText(to!string(fromStringz(ztext)));
}

// --- Слот кнопки: легальный D-контекст Qt -> evalForth ---
extern(C) void onClicked(void* dthis, int n) {
    evalForth("1 COUNTER +! UPDATE-LABEL");
}

// Загрузка файла Форта построчно (INCLUDED в ядре убран - хост читает сам)
void loadForthFile(string name) {
    string path = exists("forth/" ~ name) ? "forth/" ~ name : name;
    if (!exists(path)) { writeln("Файл не найден: ", name); return; }
    File f = File(path, "r");
    foreach (line; f.byLine()) evalForth(cast(string)line);
}

void main() {
    version(X86) { LoadQt("./dll/dll32"); } else { LoadQt("./dll/dll64"); }

    // 1) Qt-объекты (еще не показаны)
    g_app = new QApplication("forthD + QtE56");
    auto win = new QWidget(null);
    win.setWindowTitle("forthD + QtE56 demo - click the button!");
    win.resize(400, 160);
    auto vbox = new QVBoxLayout(win.getWH());
    g_lbl = new QLabel("...", cast(void*)null);
    vbox.addWidget(g_lbl);
    auto btn = new QPushButton("Click me!", win.getWH());
    vbox.addWidget(btn);
    auto eslot = new ESlot(btn.getWH());
    eslot.set(cast(void*)&onClicked);
    connectQt(btn.getWH(), "clicked()", eslot, "invoke_v()");

    // 2) Форт: ядро, библиотеки, шим (ДО qt_app.f!), логика приложения
    initForth();
    loadForthFile("stdlib.f");
    loadForthFile("heap.f");
    loadForthFile("strings.f");
    loadForthFile("console.f");
    setCommonAdr(30, cast(pp)&fw_setText);
    loadForthFile("qt_app.f");
    evalForth("RESTART");   // начальная надпись ставится самим Фортом

    // 3) Самотест без мыши: три "клика" через evalForth напрямую
    evalForth("1 COUNTER +! UPDATE-LABEL");
    evalForth("1 COUNTER +! UPDATE-LABEL");
    evalForth("1 COUNTER +! UPDATE-LABEL");
    write("Счётчик после 3 имитированных кликов: ");
    evalForth("COUNTER @ .");   // ожидается 3
    writeln();
    evalForth("RESTART");       // живому пользователю - с чистого листа

    // 4) Показ и цикл событий (клики мышью идут по тому же пути, что самотест)
    win.show();
    g_app.exec();
    g_app.deleteApp();
}
