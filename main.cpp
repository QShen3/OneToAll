#include <QApplication>
#include <QDebug>
#include <QTranslator>

#include "UserData.h"
#include "Settings.h"
#include "Utility.h"
#include "HttpRequest.h"
#ifdef Q_OS_IOS
#include "UIButton.h"
#endif

#if QT_VERSION < 0x050000
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#include "MyImage.h"
#else
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
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
    //QQuickView viewer;

    engine.rootContext()->setContextProperty("userdata",&userData);
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("utility",&utility);
    engine.rootContext()->setContextProperty("httprequest",&httpRequest);

#ifdef Q_OS_ANDROID
    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));
    //viewer.show();
#elif defined(Q_OS_IOS)
    qmlRegisterType<QUIButton>("com.qshen.ios", 0, 1, "UIButton");
    engine.load(QUrl(QStringLiteral("qrc:/qml/IOS/main.qml")));


    //viewer.show();
#endif

#endif

    return app.exec();

}
