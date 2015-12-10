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
    NetworkAccessManagerFactory factory;

#if QT_VERSION < 0x050000
    QmlApplicationViewer viewer;

    viewer.engine()->setNetworkAccessManagerFactory(&factory);
    viewer.rootContext()->setContextProperty("userdata",&userData);
    viewer.rootContext()->setContextProperty("settings", &settings);
    viewer.rootContext()->setContextProperty("utility",&utility);
    viewer.rootContext()->setContextProperty("httprequest",&httpRequest);

    qmlRegisterType<MyImage>("com.stars.widgets", 1, 0, "MyImage");

#ifdef Q_OS_SYMBIAN
    viewer.setSource(QUrl("qml/Symbian3/main.qml"));
#elif defined(Q_OS_HARMATTAN) | defined(Q_WS_SIMULATOR)
    viewer.setSource(QUrl("qrc:/qml/Meego/main.qml"));
#endif
    viewer.showExpanded();
#else
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("userdata",&userData);
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("utility",&utility);
    engine.rootContext()->setContextProperty("httprequest",&httpRequest);

#ifdef Q_OS_ANDROID
    engine.load(QUrl(QStringLiteral("qrc:/qml/Android/main.qml")));
#elif defined(Q_OS_IOS)
    qmlRegisterType<QUIButton>("com.qshen.ios", 0, 1, "UIButton");
    engine.load(QUrl(QStringLiteral("qrc:/qml/IOS/main.qml")));
#endif

#endif

    return app.exec();

}
