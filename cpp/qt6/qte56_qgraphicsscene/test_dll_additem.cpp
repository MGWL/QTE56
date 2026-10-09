#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QGraphicsRectItem>
#include <QGraphicsEllipseItem>
#include <QTimer>
#include <iostream>

// Имитируем DLL функции
extern "C" {
    void* qteQGraphicsTextItem_create(void* parent) {
        return new QGraphicsTextItem((QGraphicsItem*)parent);
    }
    void qteQGraphicsScene_addItem(void* w, void* item) {
        ((QGraphicsScene*)w)->addItem((QGraphicsItem*)item);
    }
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QGraphicsScene scene;
    scene.setSceneRect(0, 0, 800, 600);
    
    QGraphicsView view;
    view.setScene(&scene);
    view.resize(800, 600);
    view.show();
    
    std::cout << "Creating text item via DLL-style..." << std::endl;
    void* textItem = qteQGraphicsTextItem_create(nullptr);
    std::cout << "Text item created at " << textItem << std::endl;
    
    ((QGraphicsTextItem*)textItem)->setPlainText("Hello!");
    std::cout << "Plain text set" << std::endl;
    
    std::cout << "Adding to scene..." << std::endl;
    qteQGraphicsScene_addItem(&scene, textItem);
    std::cout << "Added to scene!" << std::endl;
    
    // Rect item
    void* rectItem = new QGraphicsRectItem(0, 0, 100, 80);
    ((QGraphicsRectItem*)rectItem)->setBrush(QBrush(QColor(255, 0, 0)));
    qteQGraphicsScene_addItem(&scene, rectItem);
    std::cout << "Rect added!" << std::endl;
    
    // Ellipse item
    void* ellipseItem = new QGraphicsEllipseItem(0, 0, 120, 120);
    ((QGraphicsEllipseItem*)ellipseItem)->setBrush(QBrush(QColor(0, 255, 0)));
    qteQGraphicsScene_addItem(&scene, ellipseItem);
    std::cout << "Ellipse added!" << std::endl;
    
    std::cout << "All done!" << std::endl;
    
    QTimer::singleShot(2000, &app, &QApplication::quit);
    return app.exec();
}
