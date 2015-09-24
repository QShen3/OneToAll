#include <QApplication>
#include <QDebug>
#include <QTranslator>

#include "UserData.h"
#include "Settings.h"
#include "Utility.h"
#include "HttpRequest.h"

#if QT_VERSION < 0x050000
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#include "MyImage.h"
#else
#include <QQmlApplicationEngine>
#include <QQmlContext>
#endif


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
    Settings settings;
    Utility utility;
    HttpRequest httpRequest;

#if QT_VERSION < 0x050000
    QmlApplicationViewer viewer;

    viewer.rootContext()->setContextProperty("userdata",&userData);
    viewer.rootContext()->setContextProperty("settings", &settings);
    viewer.rootContext()->setContextProperty("utility",&utility);
    viewer.rootContext()->setContextProperty("httprequest",&httpRequest);

    qmlRegisterType<MyImage>("com.stars.widgets", 1, 0, "MyImage");

    //viewer.setAttribute(Qt::WA_LockPortraitOrientation, true);
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setSource(QUrl("qml/Symbian3/main.qml"));
    viewer.showExpanded();
#else
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("userdata",&userData);
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("utility",&utility);
    engine.rootContext()->setContextProperty("httprequest",&httpRequest);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));
#endif

    return app.exec();

}
