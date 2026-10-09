#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QGraphicsRectItem>
#include <QTimer>
#include <iostream>

extern "C" {
    void* qteQGraphicsTextItem_create(void* parent) {
        QGraphicsTextItem* item = new QGraphicsTextItem((QGraphicsItem*)parent);
        return item;
    }
    void* qteQGraphicsRectItem_create(double x, double y, double w, double h, void* parent) {
        QGraphicsRectItem* item = new QGraphicsRectItem(x, y, w, h, (QGraphicsItem*)parent);
        return item;
    }
    void qteQGraphicsScene_addItem(void* w, void* item) {
        ((QGraphicsScene*)w)->addItem((QGraphicsItem*)item);
    }
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QGraphicsScene scene;
    QGraphicsView view;
    view.setScene(&scene);
    view.show();
    
    // Сначала rect item (работает?)
    std::cout << "Creating rect item..." << std::endl;
    void* rectItem = qteQGraphicsRectItem_create(0, 0, 100, 80, nullptr);
    ((QGraphicsRectItem*)rectItem)->setBrush(QBrush(QColor(255, 0, 0)));
    std::cout << "Adding rect to scene..." << std::endl;
    qteQGraphicsScene_addItem(&scene, rectItem);
    std::cout << "Rect added!" << std::endl;
    
    // Теперь text item
    std::cout << "Creating text item..." << std::endl;
    void* textItem = qteQGraphicsTextItem_create(nullptr);
    std::cout << "Setting text..." << std::endl;
    ((QGraphicsTextItem*)textItem)->setPlainText("Hello!");
    std::cout << "Text pos before add: " << ((QGraphicsTextItem*)textItem)->pos().x() << "," << ((QGraphicsTextItem*)textItem)->pos().y() << std::endl;
    std::cout << "Adding text to scene..." << std::endl;
    
    // Попробуем напрямую через scene
    scene.addItem((QGraphicsTextItem*)textItem);
    std::cout << "Text added directly!" << std::endl;
    
    QTimer::singleShot(500, &app, &QApplication::quit);
    return app.exec();
}
