#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>
#include "UserData.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QString locale = QLocale::system().name();
    QTranslator translator;
    if(!translator.load(QString("onetoall_") + locale,":/i18n")){
        qDebug()<<"here";
    }
    app.installTranslator(&translator);

    UserData userdata;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("userdata",&userdata);

    //qDebug()<<"here";
    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));

    return app.exec();
}
