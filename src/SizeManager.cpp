#include <QScreen>
#include <QDebug>
#include <QGuiApplication>
#include "SizeManager.h"
SizeManager::SizeManager()
{
    screen = QGuiApplication::primaryScreen();
    qDebug()<<"logical dpi"<<screen->logicalDotsPerInch();
    qDebug()<<"physical dpi"<<screen->physicalDotsPerInch();
}

qreal SizeManager::dp(qreal dpsize)
{    
    return dpsize*(screen->physicalDotsPerInch()/160);
}
