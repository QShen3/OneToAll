TEMPLATE = app

QT += qml quick widgets svg network

!osx:qtHaveModule(webengine) {
        QT += webengine
        DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
}

INCLUDEPATH += src

SOURCES += main.cpp \
    src/UserData.cpp \
    src/Utility.cpp \
    src/HttpRequest.cpp \
    src/Settings.cpp

HEADERS += \
    src/UserData.h \
    src/Utility.h \
    src/HttpRequest.h \
    src/Settings.h

RESOURCES += \
    OneToAll.qrc        #js files and pic files

TRANSLATIONS += i18n/onetoall_zh.ts

OTHER_FILES += \
    qml/JavaScript/*.js \
    qml/pic/*.svg \
    qml/pic/*.png

folder_Symbian.source = qml/Symbian3
folder_Symbian.target = qml

folder_Meego.source = qml/Meego
folder_Meego.target = qml

folder_pic.source = qml/pic
folder_pic.target = qml

folder_JS.source = qml/JavaScript
folder_JS.target = qml

mac{
    RESOURCES += Android.qrc
}

ios{
    RESOURCES += Android.qrc
}

android{

    QT += androidextras

    RESOURCES += Android.qrc      #Android qml

    OTHER_FILES += \
        qml/Android/*.qml \
        qml/Android/BaseComponent/*.qml \
        qml/Android/Delegate/*.qml \
        qml/Android/Dialog/*.qml


    DISTFILES += \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/AndroidManifest.xml \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/src/com/qshen/onetoall/ImagePicker.java          #java files

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    include(deployment.pri)
}

simulator{
    SOURCES += \
        src/MyImage.cpp

    HEADERS += \
        src/MyImage.h

    DEPLOYMENTFOLDERS += folder_Symbian folder_pic folder_JS

    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    qtcAddDeployment()
}

symbian{
    TARGET = OneToAll
    VERSION = 0.5.1
    DEFINES += VER=\"$$VERSION\"
    vendorinfo = "%{\"QShen\"}" ":\"QShen\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT.display_name = OneToAll
    DEPLOYMENT += my_deployment

    TARGET.UID3 = 0xE3C7B1EC
    TARGET.CAPABILITY += NetworkServices \
        ReadUserData \
        ReadDeviceData \
        LocalServices \
        Location \
        UserEnvironment \
        WriteUserData \
        WriteDeviceData

    CONFIG += localize_deployment

    LIBS *= \
        -lMgFetch -lbafl \                   #select iamge
        -lServiceHandler -lnewservice -lbafl        #capture
    #INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
    SOURCES += \
        src/MyImage.cpp

    HEADERS += \
        src/MyImage.h

    DEPLOYMENTFOLDERS += folder_Symbian folder_pic folder_JS
    #RESOURCES += Symbian3.qrc

    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    qtcAddDeployment()
}

contains(MEEGO_EDITION,harmattan){

    DEFINES += Q_OS_HARMATTAN
    CONFIG += qdeclarative-boostable meegotouch
    DEPLOYMENTFOLDERS +=  folder_JS folder_Meego folder_pic
    #RESOURCES += Meego.qrc

    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/changelog

    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    qtcAddDeployment()

}








