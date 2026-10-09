#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QGraphicsRectItem>
#include <QGraphicsEllipseItem>
#include <QTimer>
#include <iostream>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    std::cout << "Creating scene..." << std::endl;
    QGraphicsScene scene;
    scene.setSceneRect(0, 0, 800, 600);
    
    std::cout << "Creating view..." << std::endl;
    QGraphicsView view;
    view.setScene(&scene);
    view.resize(800, 600);
    view.show();
    
    std::cout << "Creating text item..." << std::endl;
    QGraphicsTextItem* textItem = new QGraphicsTextItem();
    textItem->setPlainText("Hello!");
    textItem->setPos(100, 20);
    scene.addItem(textItem);
    std::cout << "Text item added" << std::endl;
    
    std::cout << "Creating rect item..." << std::endl;
    QGraphicsRectItem* rectItem = new QGraphicsRectItem(0, 0, 100, 80);
    rectItem->setPos(50, 150);
    rectItem->setBrush(QBrush(QColor(255, 0, 0, 200)));
    scene.addItem(rectItem);
    std::cout << "Rect item added" << std::endl;
    
    std::cout << "Creating ellipse item..." << std::endl;
    QGraphicsEllipseItem* ellipseItem = new QGraphicsEllipseItem(0, 0, 120, 120);
    ellipseItem->setPos(300, 150);
    ellipseItem->setBrush(QBrush(QColor(0, 255, 0, 200)));
    scene.addItem(ellipseItem);
    std::cout << "Ellipse item added" << std::endl;
    
    std::cout << "All items created!" << std::endl;
    
    // Close after 2 seconds
    QTimer::singleShot(2000, &app, &QApplication::quit);
    return app.exec();
}
