TEMPLATE = app

equals(QT_MAJOR_VERSION, 4) {
    QT += network webkit
}
equals(QT_MAJOR_VERSION, 5) {
    QT += qml quick widgets svg network
    #DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
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
    OneToAll.qrc          #js files and pic files

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

win32-g++{
    RESOURCES += Win32.qrc

    OTHER_FILES += \
        qml/Win32/*.qml \
        qml/Win32/BaseComponent/*.qml \
        qml/Win32/Delegate/*.qml \
        qml/Win32/Dialog/*.qml


    include(deployment.pri)

    message(Win32 build)
}

winrt{
    WinRT.qrc

    OTHER_FILES += \
        qml/WinRT/*.qml \
        qml/WinRT/BaseComponent/*.qml \
        qml/WinRT/Delegate/*.qml \
        qml/WinRT/Dialog/*.qml

    include(deployment.pri)

    message(WinRT build)
}

mac{
    RESOURCES += Android.qrc
}

ios{
    LIBS += -framework Foundation -framework UIKit

    HEADERS += UIButton.h

    OBJECTIVE_SOURCES += \
        src/UIButton.mm


    RESOURCES += IOS.qrc

    OTHER_FILES += \
        qml/IOS/*.qml

    include(deployment.pri)

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
    message(Android build)
}

simulator{
    SOURCES += \
        src/MyImage.cpp

    HEADERS += \
        src/MyImage.h

    RESOURCES += Meego.qrc

    DEPLOYMENTFOLDERS +=  folder_JS folder_Meego folder_pic

    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    qtcAddDeployment()
}

contains(MEEGO_EDITION,harmattan){
    QT += dbus

    DEFINES += Q_OS_HARMATTAN
    CONFIG += qdeclarative-boostable meegotouch videosuiteinterface-maemo-meegotouch

    SOURCES += \
        src/MyImage.cpp

    HEADERS += \
        src/MyImage.h

    #DEPLOYMENTFOLDERS +=  folder_JS folder_Meego folder_pic
    RESOURCES += Meego.qrc

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

symbian{
    TARGET = OneToAll
    VERSION = 0.7.4    #version code 6
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

    #DEPLOYMENTFOLDERS += folder_Symbian folder_pic folder_JS
    RESOURCES += Symbian3.qrc

    include(qmlapplicationviewer/qmlapplicationviewer.pri)
    qtcAddDeployment()
}










