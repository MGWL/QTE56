#include <QGraphicsTextItem>
#include <QGraphicsRectItem>
#include <QGraphicsItem>
#include <iostream>

int main() {
    QGraphicsTextItem* text = new QGraphicsTextItem();
    void* voidPtr = text;
    
    std::cout << "QGraphicsTextItem* = " << text << std::endl;
    std::cout << "void* = " << voidPtr << std::endl;
    std::cout << "(QGraphicsItem*)text = " << (QGraphicsItem*)text << std::endl;
    std::cout << "(QGraphicsItem*)voidPtr = " << (QGraphicsItem*)voidPtr << std::endl;
    
    QGraphicsRectItem* rect = new QGraphicsRectItem();
    void* voidPtr2 = rect;
    
    std::cout << "\nQGraphicsRectItem* = " << rect << std::endl;
    std::cout << "void* = " << voidPtr2 << std::endl;
    std::cout << "(QGraphicsItem*)rect = " << (QGraphicsItem*)rect << std::endl;
    std::cout << "(QGraphicsItem*)voidPtr2 = " << (QGraphicsItem*)voidPtr2 << std::endl;
    
    return 0;
}
