#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>
#include "UserData.h"
#include "Utility.h"

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
    Utility utility;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("userdata",&userdata);
    engine.rootContext()->setContextProperty("utility",&utility);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));

    return app.exec();
}
