#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsPixmapItem>
#include <QPixmap>
#include <cstdio>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    printf("QApplication created\n");
    
    QGraphicsScene scene;
    printf("Scene created\n");
    
    QGraphicsPixmapItem* item = new QGraphicsPixmapItem();
    printf("Item created at %p\n", item);
    
    item->setPos(100, 100);
    printf("setPos OK\n");
    
    scene.addItem(item);
    printf("addItem OK\n");
    
    return 0;
}
