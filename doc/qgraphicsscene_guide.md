# QGraphicsScene / QGraphicsView / QGraphicsPixmapItem — Руководство

> ↑ Навигация: [AGENTS.md](../AGENTS.md) → [AI_DRAWING.md](../AI_DRAWING.md)

## Обзор

Модуль `QGraphicsScene` предоставляет 2D-графический движок для работы со спрайтами:
- **QGraphicsScene** — контейнер для спрайтов (игровой мир)
- **QGraphicsView** — окно просмотра сцены
- **QGraphicsPixmapItem** — спрайт (картинка на сцене)

## Загрузка

```d
import gen_qgraphicsscene;
LoadQt("./dll");  // загружает qte56_qgraphicsscene.dll
```

## Быстрый старт

```d
@live auto app = new QApplication("my_game");

// 1. Создаём сцену
@live auto scene = new QGraphicsScene(null);
scene.setSceneRect(0, 0, 800, 600);

// 2. Создаём окно просмотра
@live auto view = new QGraphicsView(null);
view.setScene(scene);
view.resize(800, 600);
view.show();

// 3. Создаём спрайт
@live auto pixmap = new QPixmap(64, 64);
pixmap.fill(255, 0, 0, 255);  // R=255, G=0, B=0, A=255 — красный
@live auto sprite = new QGraphicsPixmapItem(pixmap.getWH(), null);
sprite.setPos(100, 100);

// 4. Добавляем на сцену
scene.addItem(sprite);
scene.updateScene();
```

## API Reference

### QGraphicsScene

| Метод | Описание |
|-------|----------|
| `this(void* parent)` | Конструктор |
| `setSceneRect(x, y, w, h)` | Задать границы сцены |
| `addItem(item)` | Добавить спрайт |
| `removeItem(item)` | Удалить спрайт |
| `clear()` | Очистить сцену |
| `updateScene()` | Перерисовать |

### QGraphicsView

| Метод | Описание |
|-------|----------|
| `this(void* parent)` | Конструктор |
| `setScene(scene)` | Привязать сцену |
| `resize(w, h)` | Изменить размер |
| `show()` | Показать окно |
| `hide()` | Скрыть окно |
| `setRenderHint(hint, on)` | Включить сглаживание |
| `scale(sx, sy)` | Масштабировать вид |
| `rotate(angle)` | Повернуть вид |
| `fitInView(x, y, w, h, mode)` | Вписать область |

### QGraphicsPixmapItem (спрайт)

| Метод | Описание |
|-------|----------|
| `this(void* pixmap, void* parentItem)` | Конструктор |
| `setPos(x, y)` | Позиция |
| `setScale(scale)` | Масштаб |
| `setRotation(angle)` | Угол поворота |
| `setZValue(z)` | Z-order (глубина) |
| `setOffset(x, y)` | Смещение |
| `setOpacity(opacity)` | Прозрачность 0..1 |
| `setTransformationMode(mode)` | Smooth/Fast |

## Пример: несколько спрайтов

```d
// Красный спрайт
@live auto red = new QPixmap(64, 64);
red.fill(255, 0, 0, 255);  // красный
@live auto s1 = new QGraphicsPixmapItem(red.getWH(), null);
s1.setPos(50, 50);
scene.addItem(s1);

// Зелёный, увеличенный
@live auto green = new QPixmap(96, 96);
green.fill(0, 255, 0, 255);  // зелёный
@live auto s2 = new QGraphicsPixmapItem(green.getWH(), null);
s2.setPos(200, 100);
s2.setScale(1.5);
scene.addItem(s2);

// Синий, повёрнутый, поверх всех
@live auto blue = new QPixmap(48, 48);
blue.fill(0, 0, 255, 255);  // синий
@live auto s3 = new QGraphicsPixmapItem(blue.getWH(), null);
s3.setPos(400, 200);
s3.setRotation(45);
s3.setZValue(1);
scene.addItem(s3);
```

## Важные замечания

1. **Владение спрайтами**: При `addItem()` сцена становится владельцем спрайта. D-деструктор пропускает удаление.

2. **Порядок создания**: `QApplication` должен быть создан ДО `QGraphicsView`.

3. **Цвета в fill()**: Метод принимает 4 параметра `(r, g, b, a)`, не `uint` ARGB.

4. **QGraphicsView — standalone класс**: Не наследуется от QWidget, поэтому использует собственные методы `resize/show/hide`.

## Файлы

- `d/gen/gen_qgraphicsscene.d` — D-обёртка
- `cpp/qt5/qte56_qgraphicsscene/qte56_qgraphicsscene.cpp` — C++ DLL
- `dll/dll32/qte56_qgraphicsscene.dll` — скомпилированная DLL
- `test/test_sprites.d` — тест/демо
