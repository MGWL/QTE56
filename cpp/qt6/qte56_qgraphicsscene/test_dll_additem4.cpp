#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsTextItem>
#include <QTimer>
#include <iostream>

extern "C" {
    void* qteQGraphicsTextItem_create(void* parent) {
        QGraphicsTextItem* item = new QGraphicsTextItem((QGraphicsItem*)parent);
        std::cout << "Created QGraphicsTextItem at " << item << std::endl;
        return item;
    }
    void qteQGraphicsScene_addItem(void* w, void* item) {
        std::cout << "qteQGraphicsScene_addItem: scene=" << w << " item=" << item << std::endl;
        QGraphicsItem* gItem = (QGraphicsItem*)item;
        std::cout << "Cast to QGraphicsItem* = " << gItem << std::endl;
        std::cout << "Calling addItem..." << std::endl;
        ((QGraphicsScene*)w)->addItem(gItem);
        std::cout << "addItem returned" << std::endl;
    }
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QGraphicsScene scene;
    QGraphicsView view;
    view.setScene(&scene);
    view.show();
    
    void* textItem = qteQGraphicsTextItem_create(nullptr);
    ((QGraphicsTextItem*)textItem)->setPlainText("Hello!");
    qteQGraphicsScene_addItem(&scene, textItem);
    std::cout << "Done!" << std::endl;
    
    QTimer::singleShot(500, &app, &QApplication::quit);
    return app.exec();
}
