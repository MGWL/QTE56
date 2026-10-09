#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QTimer>
#include <iostream>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QGraphicsScene scene;
    QGraphicsView view;
    view.setScene(&scene);
    view.show();
    
    std::cout << "Creating text item..." << std::endl;
    QGraphicsTextItem* textItem = new QGraphicsTextItem();
    std::cout << "Setting text..." << std::endl;
    textItem->setPlainText("Hello!");
    std::cout << "Adding to scene..." << std::endl;
    scene.addItem(textItem);
    std::cout << "Done!" << std::endl;
    
    QTimer::singleShot(500, &app, &QApplication::quit);
    return app.exec();
}
