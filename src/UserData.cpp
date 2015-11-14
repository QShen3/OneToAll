#include "UserData.h"
#if QT_VERSION < 0x050000
#include <QDesktopServices>
#else
#include <QStandardPaths>
#endif
#include <QDir>
#include <QTextStream>
void UserData::setUserData(const QString &key, const QString &data){
#if QT_VERSION < 0x050000
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation) + QDir::separator() + ".userdata";
#else
    QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + ".userdata";
#endif
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(path);

    QString filename = path + QDir::separator() + key + ".dat";
    QFile file(filename);
    if(file.open(QIODevice::WriteOnly)){
        QTextStream stream(&file);
        stream << data;
        file.close();
    }
}

QString UserData::getUserData(const QString &key){
#if QT_VERSION < 0x050000
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation) + QDir::separator() + ".userdata";
#else
    QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + ".userdata";
#endif
    QString filename = path + QDir::separator() + key + ".dat";
    QString res;
    QFile file(filename);
    if (file.exists() && file.open(QIODevice::ReadOnly)){
        QTextStream stream(&file);
        res = stream.readAll();
        file.close();
    }
    return res;
}

bool UserData::clearUserData(const QString &key){
#if QT_VERSION < 0x050000
    QString path = QDesktopServices::storageLocation(QDesktopServices::DataLocation) + QDir::separator() + ".userdata";
#else
    QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + ".userdata";
#endif
    QString filename = path + QDir::separator() + key + ".dat";
    QFile file(filename);
    return file.remove();
}
