#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>
#include "UserData.h"
#include "Utility.h"
#include "HttpRequest.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QString locale = QLocale::system().name();
    QTranslator translator;
    if(!translator.load(QString("onetoall_") + locale,":/i18n")){
        qDebug()<<"translator load erro";
    }
    app.installTranslator(&translator);

    UserData userData;
    Utility utility;
    HttpRequest httpRequest;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("userdata",&userData);
    engine.rootContext()->setContextProperty("utility",&utility);
    engine.rootContext()->setContextProperty("httprequest",&httpRequest);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));

    return app.exec();
}
