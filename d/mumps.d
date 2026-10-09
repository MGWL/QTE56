/**
 * d/mumps.d — высокоуровневая обёртка над локальной MiniMono VM.
 *
 * Идея: вместо того чтобы вручную собирать M-команды строкой и заботиться об
 * экранировании кавычек, работать с глобалами/локалами как с типизированным
 * key-value хранилищем.
 *
 * Сравните:
 *
 *   // Раньше (через Execute):
 *   string mCmd = `s ^PATIENT(123,"name")="` ~ kaw2(value) ~ `"`;
 *   vm.cbfunc.Execute(&cmd_buf);
 *
 *   // С MumpsVM:
 *   mvm.set("PATIENT", ["123", "name"], value);
 *
 * Все строки на входе/выходе — UTF-8 D-string. Внутри обёртка конвертирует
 * в cp1251 через QTextCodec — на этой стороне M-VM работает с cp1251.
 *
 * Используется только локальная VM (cbfunc.* функции). Серверный режим
 * (MNM* через minimsc.dll) пока не реализован — добавить можно отдельным
 * backend'ом, когда понадобится.
 *
 * Зависимости:
 *   - src_m/minimono.d — MINIMONOVM struct
 *   - src_m/zdll.d     — ZDLLCB callback list, MINIM_STR
 *   - QTextCodec       — конвертация cp1251 ↔ UTF-8
 *
 * Пример использования (Load Routine):
 *
 *   auto mvm = new MumpsVM(&g_main.vm);
 *   if (!mvm.exists("ROUTINE", [name])) return -1;
 *   foreach (idx; mvm.children("ROUTINE", [name]))
 *       writeln(idx, ": ", mvm.get("ROUTINE", [name, idx]));
 */
module mumps;

import std.string : toStringz, strip;
import std.conv   : to;

import minimono;       // MINIMONOVM, MINIM_STR alias
import zdll;            // _ZDLLCB, MINIM_STR_MAX
import gen_qtextcodec;  // QTextCodec

// Status codes возвращаемые callback-функциями VM (из zdll.h, в zdll.d описаны
// только комментарием — поэтому определяем здесь):
private enum int ZDLL_CALLBACK_DONE       = 0;  // ok
private enum int ZDLL_CALLBACK_SYNTAX     = 1;  // синтаксическая ошибка в параметрах
private enum int ZDLL_CALLBACK_PARAMETERS = 2;  // null-параметры
private enum int ZDLL_CALLBACK_ARGC       = 3;  // слишком много argc
private enum int ZDLL_CALLBACK_UNDEFINED  = 4;  // переменная не определена
private enum int ZDLL_CALLBACK_ERROR      = 5;  // database/process error
private enum int ZDLL_CALLBACK_HALT       = 6;  // halt-команда

// ─────────────────────────────────────────────────────────────────────────────
// Исключения
// ─────────────────────────────────────────────────────────────────────────────

/// Ошибка при работе с MUMPS VM.
/// `query` — M-выражение или имя глобала, на котором произошла ошибка
/// (для удобства диагностики).
class MumpsError : Exception {
    string query;
    int    code;

    this(string msg, string query_ = "", int code_ = 0,
         string file = __FILE__, size_t line = __LINE__)
    {
        super(msg ~ (query_.length ? " [" ~ query_ ~ "]" : ""), file, line);
        this.query = query_;
        this.code  = code_;
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MumpsVM — основной класс
// ─────────────────────────────────────────────────────────────────────────────

/// Лимит глубины индексов для одного вызова. Реальные базы редко превышают
/// 5-7 уровней. 16 — с большим запасом.
private enum int MAX_SUBS = 16;

/// Высокоуровневая обёртка над `MINIMONOVM`.
///
/// **Жизненный цикл**: MumpsVM не владеет VM — указатель на `MINIMONOVM`
/// принадлежит вызывающему коду (обычно `CFormaMain.vm` в MIDE). Создание/
/// уничтожение VM (`CreateMiniMonoVM`/`FreeMiniMonoVM`) — ответственность
/// пользователя; MumpsVM просто использует cbfunc.
///
/// **Потоки**: NOT thread-safe. MiniMono VM — single-threaded. Если нужен
/// доступ из нескольких D-потоков — синхронизировать снаружи.
@live class MumpsVM
{
    // ── Состояние ────────────────────────────────────────────────────────────

    /// Указатель на VM (не владеет — VM создаётся/удаляется снаружи).
    private MINIMONOVM* _vm;

    /// Конструктор. `vm` — pointer на инициализированную VM
    /// (после `CreateMiniMonoVM`).
    this(MINIMONOVM* vm)
    {
        _vm = vm;
    }

    /// Готова ли VM к работе (cbfunc заполнен после CreateMiniMonoVM).
    bool isReady() const
    {
        return _vm !is null && _vm.cbfunc !is null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ГЛОБАЛЫ — ^NAME(sub1, sub2, ...) — постоянное хранилище
    // ─────────────────────────────────────────────────────────────────────────

    /// Записать значение в узел глобала.
    /// `name` — имя глобала БЕЗ префикса `^` (например, `"PATIENT"`).
    /// `subs` — массив индексов (UTF-8 строки; для чисел — `i.to!string`).
    /// `value` — записываемое значение (UTF-8).
    void set(string name, string[] subs, string value)
    {
        ensureReady();
        if (_vm.cbfunc.WriteGlobal is null)
            throw new MumpsError("WriteGlobal недоступна в этой версии VM");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR valBuf;
        packString(&valBuf, value);

        auto cName = name.toStringz;
        int rc = _vm.cbfunc.WriteGlobal(
            cast(char*)cName, null,
            cast(int)subs.length,
            subPtrs.ptr,
            &valBuf);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("WriteGlobal failed", "^" ~ name, rc);
    }

    /// Прочитать значение узла глобала. Если узел не существует или его
    /// значение пустое — вернётся `""`. Для различения этих случаев —
    /// см. `exists()` / `dataState()`.
    string get(string name, string[] subs)
    {
        ensureReady();
        if (_vm.cbfunc.ReadGlobal is null)
            throw new MumpsError("ReadGlobal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR resBuf;
        auto cName = name.toStringz;
        int rc = _vm.cbfunc.ReadGlobal(
            cast(char*)cName, null,
            cast(int)subs.length,
            subPtrs.ptr,
            &resBuf);
        // ZDLL_CALLBACK_UNDEFINED = 4 — узел не определён, это не ошибка.
        if (rc == ZDLL_CALLBACK_UNDEFINED) return "";
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("ReadGlobal failed", "^" ~ name, rc);

        return unpackResult(&resBuf);
    }

    /// Удалить узел глобала (и все его подузлы). Если `subs` пустой —
    /// удаляется ВЕСЬ глобал `^name`. Будьте осторожны.
    void kill(string name, string[] subs = [])
    {
        ensureReady();
        if (_vm.cbfunc.KillGlobal is null)
            throw new MumpsError("KillGlobal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        auto cName = name.toStringz;
        int rc = _vm.cbfunc.KillGlobal(
            cast(char*)cName, null,
            cast(int)subs.length,
            subPtrs.ptr);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("KillGlobal failed", "^" ~ name, rc);
    }

    /// Получить «$D-state» узла глобала:
    ///   0  — нет ни значения, ни подузлов;
    ///   1  — есть значение, нет подузлов;
    ///   10 — нет значения, есть подузлы;
    ///   11 — есть и значение, и подузлы.
    int dataState(string name, string[] subs)
    {
        ensureReady();
        if (_vm.cbfunc.DataGlobal is null)
            throw new MumpsError("DataGlobal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR resBuf;
        auto cName = name.toStringz;
        int rc = _vm.cbfunc.DataGlobal(
            cast(char*)cName, null,
            cast(int)subs.length,
            subPtrs.ptr,
            &resBuf);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("DataGlobal failed", "^" ~ name, rc);

        return _vm.cbfunc.GetInt32(&resBuf);
    }

    /// Существует ли узел (есть значение или подузлы).
    bool exists(string name, string[] subs) {
        return dataState(name, subs) != 0;
    }

    /// Имеет ли узел собственное значение (не только подузлы).
    bool hasValue(string name, string[] subs) {
        int d = dataState(name, subs);
        return d == 1 || d == 11;
    }

    /// Имеет ли узел подузлы.
    bool hasChildren(string name, string[] subs) {
        int d = dataState(name, subs);
        return d == 10 || d == 11;
    }

    /// Атомарный инкремент `$I(^name(subs), delta)`. Возвращает новое значение.
    /// cbfunc.IncGlobal всегда инкрементирует на +1 (delta в сигнатуре
    /// MiniMono zdll не предусмотрена — проверено экспериментально: лишние
    /// элементы argv трактуются как дополнительные индексы). Поэтому
    /// delta == 1 идёт напрямую через IncGlobal, остальные значения —
    /// через Eval `$I(^name(...), delta)` (поддерживается и отрицательная delta).
    long inc(string name, string[] subs, long delta = 1)
    {
        ensureReady();

        if (delta != 1) {
            // Собираем $I(^name("s1","s2"),delta); кавычки в индексах удваиваем.
            string expr = `$I(^` ~ name;
            if (subs.length) {
                expr ~= "(";
                foreach (i, s; subs) {
                    if (i) expr ~= ",";
                    expr ~= `"` ~ kaw2m(s) ~ `"`;
                }
                expr ~= ")";
            }
            expr ~= "," ~ delta.to!string ~ ")";
            return evalInt64(expr);
        }

        if (_vm.cbfunc.IncGlobal is null)
            throw new MumpsError("IncGlobal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR resBuf;
        auto cName = name.toStringz;
        int rc = _vm.cbfunc.IncGlobal(
            cast(char*)cName, null,
            cast(int)subs.length,
            subPtrs.ptr,
            &resBuf);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("IncGlobal failed", "^" ~ name, rc);
        return _vm.cbfunc.GetInt64(&resBuf);
    }

    /// `$O(^name(subs..., start))` — следующий индекс после `start` на уровне
    /// `subs.length + 1`. Передайте `start = ""` чтобы получить ПЕРВЫЙ индекс.
    /// Возвращает `""` когда индексов больше нет.
    string nextSub(string name, string[] subs, string start = "") {
        return orderImpl(name, subs, start, true);
    }

    /// `$O(^name(subs..., start), -1)` — предыдущий индекс.
    string prevSub(string name, string[] subs, string start = "") {
        return orderImpl(name, subs, start, false);
    }

    /// Получить ВСЕ непосредственные подузлы (как массив строк).
    /// Например, `children("ROUTINE", ["foo"])` вернёт `["1","2","3",...]` для
    /// routine "foo" с тремя строками.
    /// Внимание: для больших глобалов лучше итерировать через `nextSub` без
    /// загрузки всего списка в память.
    string[] children(string name, string[] subs)
    {
        string[] result;
        string cur = "";
        // Защита от бесконечного цикла на повреждённых данных.
        enum int SAFETY_LIMIT = 1_000_000;
        int safety = 0;
        while (safety++ < SAFETY_LIMIT) {
            string next = nextSub(name, subs, cur);
            if (next == "") break;
            result ~= next;
            cur = next;
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ЛОКАЛЫ — name(sub1,sub2,...) — переменные сессии (не персистентны)
    // ─────────────────────────────────────────────────────────────────────────

    /// Записать локальную переменную.
    void setLocal(string name, string[] subs, string value)
    {
        ensureReady();
        if (_vm.cbfunc.WriteLocal is null)
            throw new MumpsError("WriteLocal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR valBuf;
        packString(&valBuf, value);

        auto cName = name.toStringz;
        int rc = _vm.cbfunc.WriteLocal(
            cast(char*)cName,
            cast(int)subs.length,
            subPtrs.ptr,
            &valBuf);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("WriteLocal failed", name, rc);
    }

    /// Прочитать локальную переменную.
    string getLocal(string name, string[] subs)
    {
        ensureReady();
        if (_vm.cbfunc.ReadLocal is null)
            throw new MumpsError("ReadLocal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        MINIM_STR resBuf;
        auto cName = name.toStringz;
        int rc = _vm.cbfunc.ReadLocal(
            cast(char*)cName,
            cast(int)subs.length,
            subPtrs.ptr,
            &resBuf);
        if (rc == ZDLL_CALLBACK_UNDEFINED) return "";
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("ReadLocal failed", name, rc);

        return unpackResult(&resBuf);
    }

    /// Удалить локальную переменную.
    void killLocal(string name, string[] subs = [])
    {
        ensureReady();
        if (_vm.cbfunc.KillLocal is null)
            throw new MumpsError("KillLocal недоступна");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        packSubs(subs, subBufs, subPtrs);

        auto cName = name.toStringz;
        int rc = _vm.cbfunc.KillLocal(
            cast(char*)cName,
            cast(int)subs.length,
            subPtrs.ptr);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("KillLocal failed", name, rc);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EXECUTE / EVAL — произвольные M-команды и выражения
    // ─────────────────────────────────────────────────────────────────────────

    /// Выполнить M-команду (без результата).
    /// Используется для команд вроде `D ^routine`, `LOCK +^X`, и т.п.
    /// Возврат `Execute` локальной VM для команды НЕ является статусом ошибки —
    /// ошибки M (синтаксические/runtime) приходят через WriteStr-callback в виде
    /// текстового сообщения. Поэтому мы его игнорируем.
    void execute(string cmd)
    {
        ensureReady();
        if (_vm.cbfunc.Execute is null)
            throw new MumpsError("Execute недоступна");

        MINIM_STR cmdBuf;
        packString(&cmdBuf, cmd);
        _vm.cbfunc.Execute(&cmdBuf);
    }

    /// Вычислить M-выражение и вернуть результат как строку (UTF-8).
    /// Для `$L(...)`, `$$func^routine(args)` и т.п.
    string evalString(string expr)
    {
        ensureReady();
        if (_vm.cbfunc.Eval is null)
            throw new MumpsError("Eval недоступна");

        MINIM_STR exprBuf, resBuf;
        packString(&exprBuf, expr);
        _vm.cbfunc.Eval(&exprBuf, &resBuf);
        return unpackResult(&resBuf);
    }

    /// Вычислить M-выражение и вернуть результат как 32-bit int.
    int evalInt(string expr)
    {
        ensureReady();
        MINIM_STR exprBuf, resBuf;
        packString(&exprBuf, expr);
        _vm.cbfunc.Eval(&exprBuf, &resBuf);
        return _vm.cbfunc.GetInt32(&resBuf);
    }

    /// Вычислить как 64-bit int.
    long evalInt64(string expr)
    {
        ensureReady();
        MINIM_STR exprBuf, resBuf;
        packString(&exprBuf, expr);
        _vm.cbfunc.Eval(&exprBuf, &resBuf);
        return _vm.cbfunc.GetInt64(&resBuf);
    }

    /// Вычислить как double.
    double evalDouble(string expr)
    {
        ensureReady();
        MINIM_STR exprBuf, resBuf;
        packString(&exprBuf, expr);
        _vm.cbfunc.Eval(&exprBuf, &resBuf);
        return _vm.cbfunc.GetDouble(&resBuf);
    }

    /// Получить текст последней ошибки VM.
    string lastError()
    {
        if (!isReady() || _vm.cbfunc.ErrStr is null) return "";
        MINIM_STR buf;
        _vm.cbfunc.ErrStr(&buf);
        return unpackResult(&buf);
    }

    /// Прямой доступ к `cbfunc` для случаев, не покрытых обёрткой.
    /// Возвращает `null` если VM не готова.
    _ZDLLCB* cbfunc() {
        return isReady() ? _vm.cbfunc : null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRIVATE — упаковка/распаковка MINIM_STR
    // ─────────────────────────────────────────────────────────────────────────

    private:

    /// Удвоение кавычек для M-строкового литерала (" → "").
    static string kaw2m(string s)
    {
        string rez;
        foreach (ch; s) {
            if (ch == '"') rez ~= `""`;
            else rez ~= ch;
        }
        return rez;
    }

    void ensureReady()
    {
        if (!isReady())
            throw new MumpsError("VM не инициализирована (вызовите OpenMono)");
    }

    /// UTF-8 D-string → cp1251 байты в `MINIM_STR.data` + установка `len`.
    /// Бросает `MumpsError` если строка не помещается в 32К-буфер.
    void packString(MINIM_STR* dst, string utf8)
    {
        ubyte[] bytes;
        if (utf8.length == 0) {
            dst.len = 0;
            dst.data[0] = 0;
            return;
        }
        bytes = QTextCodec.toCp1251(utf8);
        if (bytes.length >= MINIM_STR_MAX)
            throw new MumpsError("строка слишком длинная (>32К)");
        foreach (i, b; bytes) dst.data[i] = b;
        dst.data[bytes.length] = 0;
        dst.len = cast(ushort)bytes.length;
    }

    /// MINIM_STR → UTF-8 D-string. Конвертация через `cbfunc.GetStr` —
    /// VM сама нормализует MT_INT32/INT64/DOUBLE-маркеры в каноническую строку.
    string unpackResult(MINIM_STR* src)
    {
        if (src is null) return "";
        // Если ВМ положила обычную строку — len будет нормальным, но если
        // там типизированное число (MT_INT32 = 0xFFFF и т.п.) — нужна
        // конвертация через GetStr. Делаем всегда, это безопасно.
        if (_vm.cbfunc.GetStr is null) {
            // Fallback без GetStr — рискуем читать мусор для типизированных,
            // но для обычных строк работает.
            if (src.len == 0 || src.len >= MINIM_STR_MAX) return "";
            return QTextCodec.fromCp1251(src.data[0 .. src.len].dup);
        }
        MINIM_STR tmp;
        _vm.cbfunc.GetStr(src, &tmp);
        if (tmp.len == 0 || tmp.len >= MINIM_STR_MAX) return "";
        return QTextCodec.fromCp1251(tmp.data[0 .. tmp.len].dup);
    }

    /// Упаковать массив D-строк в массивы MINIM_STR (на стеке) и MINIM_STR*.
    /// `subBufs` — стек-буфер для значений, `subPtrs` — массив указателей,
    /// который и передаётся в cbfunc. Бросает MumpsError если subs.length > MAX_SUBS.
    void packSubs(string[] subs,
                  ref MINIM_STR[MAX_SUBS] subBufs,
                  ref MINIM_STR*[MAX_SUBS] subPtrs)
    {
        if (subs.length > MAX_SUBS)
            throw new MumpsError("слишком много индексов (>" ~ MAX_SUBS.to!string ~ ")");
        foreach (i, s; subs) {
            packString(&subBufs[i], s);
            subPtrs[i] = &subBufs[i];
        }
    }

    /// Реализация $O для глобала.
    string orderImpl(string name, string[] subs, string start, bool forward)
    {
        ensureReady();
        if (_vm.cbfunc.OrderGlobal is null)
            throw new MumpsError("OrderGlobal недоступна");

        // Стартовый индекс добавляется как (subs.length + 1)-й элемент в argv.
        // Поэтому в argv будет subs.length + 1 элементов.
        if (subs.length + 1 > MAX_SUBS)
            throw new MumpsError("слишком много индексов для $O");

        MINIM_STR[MAX_SUBS]  subBufs;
        MINIM_STR*[MAX_SUBS] subPtrs;
        foreach (i, s; subs) {
            packString(&subBufs[i], s);
            subPtrs[i] = &subBufs[i];
        }
        // Добавляем стартовый индекс
        packString(&subBufs[subs.length], start);
        subPtrs[subs.length] = &subBufs[subs.length];

        MINIM_STR resBuf;
        auto cName = name.toStringz;
        int rc = _vm.cbfunc.OrderGlobal(
            cast(char*)cName, null,
            cast(int)(subs.length + 1),
            subPtrs.ptr,
            forward ? 1 : -1,
            &resBuf);
        if (rc != ZDLL_CALLBACK_DONE)
            throw new MumpsError("OrderGlobal failed", "^" ~ name, rc);

        return unpackResult(&resBuf);
    }
}
