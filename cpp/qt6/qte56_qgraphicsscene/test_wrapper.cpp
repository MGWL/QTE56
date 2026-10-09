#include "qte56_qgraphicsscene.h"
#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsPixmapItem>
#include <QPixmap>
#include <cstdio>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    printf("Test wrapper with QApplication\n");
    
    void* item = qteQGraphicsPixmapItem_create(nullptr);
    printf("item = %p\n", item);
    
    if (item) {
        qteQGraphicsPixmapItem_setPos(item, 100, 100);
        printf("setPos OK\n");
    }
    
    return 0;
}
