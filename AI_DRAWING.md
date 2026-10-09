# QTE56 — AI_DRAWING (QPainter, QPixmap, QImage, QColor, QPen, QBrush)

> ↑ Навигация: [AGENTS.md](AGENTS.md) → [AI_CORE.md](AI_CORE.md)

> Используй вместе с AI_CORE.md.
> DLL: qte56_foundation.dll (QPainter, QColor, QPixmap, QImage, QFont) + qte56_drawing.dll (QPen, QBrush)
> import: gen_qpainter, gen_qpen, gen_qbrush, gen_qcolor, gen_qpixmap, gen_qimage, gen_qfont

---

## onPaint — рисование в виджете

```d
// ГЛАВНЫЙ ПАТТЕРН: рисовать только внутри onPaint!
// onPaint вызывается Qt при каждой перерисовке виджета.

__gshared QWidget g_canvas;

extern(C) void onPaint(void* dt, void* widget) {
    // widget — сырой указатель на QPaintDevice (виджет)
    // true = автоматически вызвать end() при уничтожении
    auto p = new QPainter(widget, true);

    // ... рисовать ...

    p.end();   // обязательно завершить (или auto-end если true в конструкторе)
    // НЕ вызывать widget.update() изнутри onPaint!
}

g_canvas = new QWidget(cast(void*)null);
g_canvas.onPaint(cast(void*)&onPaint);

// Запросить перерисовку:
g_canvas.update();   // асинхронно (рекомендуется)
g_canvas.repaint();  // немедленно (синхронно)
```

---

## QPainter — основные операции

```d
// import: gen_qpainter, gen_qpen, gen_qbrush, gen_qcolor
auto p = new QPainter(widget, true);

// ── Pen (контур) ──────────────────────────────────────────────────────────
p.setPen(0xFF_FF0000);                   // красный: ARGB uint
p.setPen(1);                             // 1=SolidLine, 0=NoPen, 2=DashLine
                                          // 3=DotLine 4=DashDotLine 5=DashDotDotLine
// Толстый цветной pen:
auto pen = new QPen();
pen.setColor(0xFF_0000FF);               // синий
pen.setWidth(3);
pen.setStyle(1);                         // 1=SolidLine
pen.setCapStyle(16);                     // 16=SquareCap 0=FlatCap 32=RoundCap
pen.setJoinStyle(64);                    // 64=MiterJoin 128=BevelJoin 256=RoundJoin
p.setPen(pen);

// ── Brush (заливка) ───────────────────────────────────────────────────────
p.setBrush(1);                           // 1=SolidPattern (заливка по умолчанию)
p.setBrush(0);                           // 0=NoBrush
auto brush = new QBrush();
brush.setColor(0xFF_00AA00);             // зелёный fill
brush.setStyle(1);                       // 1=SolidPattern
p.setBrush(brush);

// Удобно: заливка сразу цветом
p.fillRect(0, 0, 200, 100, 0xFF_FFFF00); // жёлтый прямоугольник

// ── Шрифт ─────────────────────────────────────────────────────────────────
auto font = new QFont("Arial"); font.setPointSize(12); font.setBold(true);
p.setFont(font.getWH());

// ── Прозрачность ─────────────────────────────────────────────────────────
p.setOpacity(0.5);                       // 0.0=прозрачный, 1.0=непрозрачный

// ── Трансформации ─────────────────────────────────────────────────────────
p.save();                  // сохранить состояние (pen/brush/transform)
p.translate(50.0, 50.0);   // сдвиг начала координат
p.rotate(45.0);            // поворот в градусах (по часовой)
p.scale(2.0, 2.0);         // масштаб
p.restore();               // восстановить состояние

// ── Отсечение ─────────────────────────────────────────────────────────────
p.setClipRect(10, 10, 200, 150);
p.setClipping(true);
p.setClipping(false);

// ── Режим компоновки ──────────────────────────────────────────────────────
p.setCompositionMode(0);   // 0=SourceOver (альфа-смешивание)
                            // 1=SourceIn 3=SourceOut 12=Xor и т.д.
```

---

## QPainter — примитивы

```d
// ── Линии ─────────────────────────────────────────────────────────────────
p.drawLine(10, 10, 200, 10);             // x1,y1,x2,y2
p.drawPoint(50, 50);

// ── Прямоугольники ────────────────────────────────────────────────────────
p.drawRect(10, 10, 200, 100);            // x,y,w,h (контур)
p.fillRect(10, 10, 200, 100, 0xFF_CCCCCC); // заливка
p.drawRoundedRect(10, 10, 200, 100, 12.0, 12.0); // скруглённые углы
p.eraseRect(50, 50, 100, 50);            // стереть (залить фоном)

// ── Эллипсы и круги ───────────────────────────────────────────────────────
p.drawEllipse(50, 50, 120, 80);          // x,y,w,h
// Круг:
p.drawEllipse(100, 100, 60, 60);         // w==h = круг

// ── Дуги, сектора ─────────────────────────────────────────────────────────
// Углы в 1/16 градуса! 360° = 360*16 = 5760
p.drawArc(50, 50, 100, 100, 0, 90*16);  // четверть дуги
p.drawPie(50, 50, 100, 100, 0, 90*16);  // сектор с заливкой
p.drawChord(50, 50, 100, 100, 0, 180*16);// хорда

// ── Текст ─────────────────────────────────────────────────────────────────
p.drawText(10, 30, "Simple text");       // x, y = baseline

// С выравниванием в прямоугольнике:
p.drawText(10, 10, 200, 40,
    0x84,                                // AlignHCenter|AlignVCenter
    "Centered text");
// Флаги текста: AlignLeft=1 AlignRight=2 AlignHCenter=4
//               AlignTop=0x20 AlignVCenter=0x80 AlignBottom=0x40
//               TextWordWrap=0x1000

// ── Изображения ───────────────────────────────────────────────────────────
// Pixmap:
p.drawPixmapAt(10, 10, pixmap.getWH());          // без масштаба
p.drawPixmap(10, 10, 100, 100, pixmap.getWH());  // с масштабом w,h

// Image:
p.drawImageAt(10, 10, image.getWH());
p.drawImage(10, 10, 100, 100, image.getWH());
```

---

## QPixmap — спрайты и иконки

```d
// import: gen_qpixmap
// Создать пустой:
auto pm = new QPixmap(200, 150);   // w, h

// Загрузить из файла:
auto pm = new QPixmap();   // пустой
bool ok = pm.load("image.png");
bool ok = pm.load("image.jpg");
bool ok = pm.load("icon.bmp");
if (pm.isNull()) { /* ошибка */ }

// Загрузить из памяти (байты):
ubyte[] pngData = /* данные PNG */;
pm.loadFromData(pngData, "PNG");
pm.loadFromData(pngData);        // без формата — автоопределение

// Сохранить:
pm.save("output.png");
pm.save("output.jpg");

// Размер:
int w = pm.width(); int h = pm.height();

// Масштабирование:
auto scaled = pm.scaled(100, 100, 1);  // aspectMode: 0=Ignore 1=KeepAspect 2=Expand
auto sw = pm.scaledToWidth(100);
auto sh = pm.scaledToHeight(80);

// Заливка:
pm.fill(255, 0, 0, 255);         // r,g,b,a — залить красным
pm.fill(0, 0, 0, 0);             // прозрачный

// Рисовать на pixmap (offscreen):
auto pm2 = new QPixmap(400, 300);
pm2.fill(255, 255, 255, 255);    // белый фон
auto p2  = new QPainter(pm2.getWH(), true);
p2.setPen(0xFF_FF0000);
p2.drawRect(10, 10, 380, 280);
p2.drawText(20, 30, "Label on pixmap");
p2.end();

// Показать в QLabel:
lbl.setPixmap(pm2.getWH());
lbl.setScaledContents(true);     // масштабировать по размеру label
```

---

## QImage — попиксельный доступ

```d
// import: gen_qimage
// Форматы: 4=Format_RGB32, 5=Format_ARGB32, 6=Format_ARGB32_Premultiplied
auto img = new QImage(400, 300, 5);  // 400x300, ARGB32
img.fill(0, 0, 0, 255);              // чёрный фон

// Попиксельный доступ:
img.setPixel(50, 50, 0xFF_FF0000);   // ARGB uint — красный пиксель
uint px = img.pixel(50, 50);         // прочитать пиксель
int r = (px >> 16) & 0xFF;
int g = (px >> 8) & 0xFF;
int b = px & 0xFF;

// Размер/формат:
int w   = img.width();
int h   = img.height();
int fmt = img.format();
int bpl = img.bytesPerLine();
int sz  = img.sizeInBytes();

// Загрузить из файла:
auto img2 = new QImage();
img2.load("photo.jpg");
img2.load("data.png");

// Загрузить из памяти:
img2.loadFromData(pngBytes, "PNG");

// Сохранить:
img2.save("output.png");
img2.save("output.jpg", 85);     // второй аргумент — качество (0-100)

// Трансформации:
auto sc  = img2.scaled(200, 200, 1);     // масштаб с сохранением пропорций
auto mir = img2.mirrored(false, true);   // зеркало по вертикали
auto cp  = img2.copy(10, 10, 100, 80);  // вырезать область
auto cvt = img2.convertToFormat(5);     // конвертировать в ARGB32
auto rgb = img2.rgbSwapped();           // swap R и B каналы
img2.invertPixels();                    // инвертировать

// Рисовать на QImage:
auto p3 = new QPainter(img2.getWH(), true);
p3.setPen(0xFF_FFFFFF);
p3.drawLine(0, 0, img2.width(), img2.height());
p3.end();

// QImage → QPixmap (для показа в виджете):
auto pm3 = new QPixmap(img2.width(), img2.height());
auto p4  = new QPainter(pm3.getWH(), true);
p4.drawImageAt(0, 0, img2.getWH());
p4.end();
lbl.setPixmap(pm3.getWH());

// Загрузить/сохранить в буфере памяти (без файла):
auto pngBuf = img2.saveToBuffer("PNG");       // → QByteArray (не ubyte[]!)
auto img3 = new QImage();
img3.loadFromData(pngBuf.toSlice(), "PNG");   // toSlice() → ubyte[]
```

---

## QColor

```d
// import: gen_qcolor
// Создать:
auto c = QColor.fromRgb(255, 128, 0);       // RGB
auto c = QColor.fromRgb(255, 128, 0, 200); // RGBA (alpha=0-255)
auto c = QColor.fromRgb(0xFF_FF8000);   // packed RGB uint
auto c = QColor.fromRgba(0xC8_FF8000);  // packed ARGB (0xAARRGGBB)
auto c = QColor.fromRgb(255, 128, 0, 200);
auto c = QColor.fromHsv(30, 255, 255);   // Hue, Sat, Val
auto c = QColor.fromHsl(30, 255, 127);   // Hue, Sat, Lightness

// Компоненты:
int r = c.red();   int g = c.green();
int b = c.blue();  int a = c.alpha();
uint rgba = c.rgba();                    // 0xAARRGGBB

// Изменить:
c.setRgb(255, 0, 0, 255);
c.setAlpha(128);

// Для QPen/fillRect: ARGB как uint
// 0xFF_RRGGBB — непрозрачный
// 0x80_RRGGBB — 50% прозрачный
// Примеры:
// 0xFF_FF0000 — красный
// 0xFF_00FF00 — зелёный
// 0xFF_0000FF — синий
// 0xFF_FFFFFF — белый
// 0xFF_000000 — чёрный
// 0xFF_808080 — серый
// 0xFF_2C3E50 — тёмно-синий (Flat UI)
// 0xFF_3498DB — голубой
// 0xFF_27AE60 — зелёный (Flat)
// 0xFF_E74C3C — красный (Flat)

// В QPainter.setPen принимает uint напрямую:
p.setPen(0xFF_FF0000);       // красный
p.fillRect(0, 0, 100, 100, 0x80_0000FF); // полупрозрачный синий
```

---

## QPen / QBrush

```d
// import: gen_qpen, gen_qbrush
// QPen — стиль контура:
auto pen = new QPen();
pen.setColor(0xFF_FF6600);   // цвет: ARGB uint
pen.setWidth(2);             // толщина (0=cosmetic = 1px)
pen.setStyle(1);             // 1=SolidLine 0=NoPen 2=DashLine 3=DotLine
pen.setCapStyle(32);         // 0=FlatCap 16=SquareCap 32=RoundCap
pen.setJoinStyle(128);       // 64=MiterJoin 128=BevelJoin 256=RoundJoin
p.setPen(pen);
p.setPen(0);                 // NoPen (без контура)

// QBrush — стиль заливки:
auto brush = new QBrush();
brush.setColor(0xFF_00AA00); // цвет: ARGB uint
brush.setStyle(1);           // 1=SolidPattern (заливка)
                              // 0=NoBrush 2=Dense1Pattern...8=Dense7Pattern
                              // 9=HorPattern 10=VerPattern 11=CrossPattern
                              // 14=DiagCrossPattern
p.setBrush(brush);
p.setBrush(0);               // NoBrush (без заливки)
```

---

## Типовые паттерны рисования

### Пользовательский виджет с рисованием
```d
// Отдельный виджет с onPaint и буферизацией:
__gshared QWidget  g_canvas;
__gshared QPixmap  g_buffer;  // offscreen buffer
__gshared int      g_cw, g_ch;

extern(C) void onCanvasResize(void* dt, int w, int h) {
    g_cw = w; g_ch = h;
    // Пересоздать буфер при изменении размера:
    if (g_buffer !is null) destroy(g_buffer);
    g_buffer = new QPixmap(w, h);
    redraw();
}

void redraw() {
    if (g_buffer is null) return;
    g_buffer.fill(255, 255, 255, 255);      // белый фон
    auto p = new QPainter(g_buffer.getWH(), true);

    p.setPen(0xFF_2C3E50); p.setBrush(1);
    p.drawRect(10, 10, g_cw - 20, g_ch - 20);
    p.setPen(0xFF_E74C3C);
    p.drawLine(10, 10, g_cw - 10, g_ch - 10);
    auto f = new QFont("Arial"); f.setPointSize(14);
    p.setFont(f.getWH());
    p.drawText(g_cw / 2 - 50, g_ch / 2, "Hello Canvas");

    p.end();
    g_canvas.update();  // запросить перерисовку
}

extern(C) void onPaint(void* dt, void* widget) {
    if (g_buffer is null) return;
    auto p = new QPainter(widget, true);
    p.drawPixmapAt(0, 0, g_buffer.getWH());  // нарисовать буфер
    p.end();
}

g_canvas = new QWidget(cast(void*)null);
g_canvas.onPaint(cast(void*)&onPaint);
g_canvas.onResize(cast(void*)&onCanvasResize);
```

### Сохранить виджет в PNG
```d
// Сделать скриншот виджета:
auto pm = new QPixmap(widget.width(), widget.height());
auto p  = new QPainter(pm.getWH(), true);
// Рендер виджета на QPainter — нет прямого render() в QTE56
// Альтернатива: QWidget.grab() если нужен полный screenshot
// Используйте QPixmap offscreen и рисуйте туда явно
p.end();
pm.save("screenshot.png");
```

### Градиент (через QImage с setPixel)
```d
// Горизонтальный градиент R→B:
auto img = new QImage(256, 50, 5);  // ARGB32
for (int x = 0; x < 256; x++) {
    uint color = 0xFF_000000 | (x << 16) | ((255-x));
    for (int y = 0; y < 50; y++)
        img.setPixel(x, y, color);
}
auto pm = new QPixmap(256, 50);
auto p  = new QPainter(pm.getWH(), true);
p.drawImageAt(0, 0, img.getWH());
p.end();
lbl.setPixmap(pm.getWH());
```

---

## Gotchas

```
1. onPaint: НЕ вызывать widget.update() изнутри onPaint — рекурсия!
2. QPainter.end() обязателен. new QPainter(widget, true) — auto-end при ~this.
3. Цвета передаются как uint 0xAARRGGBB (НЕ QColor object) в setPen/fillRect.
4. p.setPen(0) = NoPen. p.setBrush(0) = NoBrush (без заливки = только контур).
5. drawArc/Pie: углы в 1/16 градуса! 90° = 90*16 = 1440.
6. QPixmap.fill(r,g,b,a) — НЕ fill(QColor).
7. QImage.setPixel(x,y, 0xAARRGGBB) — packed ARGB.
8. Рисовать на QPixmap offscreen: new QPainter(pm.getWH(), true) — pm.getWH(), не pm!
9. QImage → QPixmap: нарисовать через QPainter на pixmap drawImageAt.
10. QPixmap/QImage — D-owned (не disown). Передавать через .getWH() в void*-API.
11. Масштаб: pm.scaled(w,h,1) — 1=KeepAspect. pm.scaled(w,h,0) — 0=Ignore (растянуть).
12. QPainter.save()/restore() — пара для временного изменения стиля/трансформации.
```
