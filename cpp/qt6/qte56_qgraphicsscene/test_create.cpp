#include <QApplication>
#include <QGraphicsScene>
#include <QGraphicsPixmapItem>
#include <QPixmap>

int main(int argc, char** argv) {
    QApplication app(argc, argv);
    
    QGraphicsScene scene;
    
    // Test 1: create without pixmap
    QGraphicsPixmapItem* item1 = new QGraphicsPixmapItem();
    scene.addItem(item1);
    
    // Test 2: create with pixmap
    QPixmap pix(100, 100);
    pix.fill(Qt::red);
    QGraphicsPixmapItem* item2 = new QGraphicsPixmapItem(pix);
    scene.addItem(item2);
    
    return 0;
}
