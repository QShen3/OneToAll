#include <QNetworkAccessManager>
#include "Downloader.h"

Downloader::Downloader(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    reply = NULL;
}

Downloader::~Downloader()
{
    manager->deleteLater();
}

void Downloader::append(QString url)
{

}
