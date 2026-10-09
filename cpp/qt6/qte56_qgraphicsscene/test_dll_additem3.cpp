#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QTimer>
#include <iostream>

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
    QGraphicsView view;
    view.setScene(&scene);
    view.show();
    
    std::cout << "Creating text item via C wrapper..." << std::endl;
    void* textItem = qteQGraphicsTextItem_create(nullptr);
    std::cout << "Setting text..." << std::endl;
    ((QGraphicsTextItem*)textItem)->setPlainText("Hello!");
    std::cout << "Adding to scene via C wrapper..." << std::endl;
    qteQGraphicsScene_addItem(&scene, textItem);
    std::cout << "Done!" << std::endl;
    
    QTimer::singleShot(500, &app, &QApplication::quit);
    return app.exec();
}
