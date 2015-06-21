TEMPLATE = app

QT += qml quick widgets svg

SOURCES += main.cpp \
    src/UserData.cpp \
    src/Downloader.cpp \
    src/Utility.cpp

HEADERS += \
    src/UserData.h \
    src/Utility.h \
    src/Downloader.h

INCLUDEPATH += src

RESOURCES += Android.qrc \
    OneToAll.qrc

TRANSLATIONS += i18n/onetoall_zh.ts

OTHER_FILES += \
        qml/JavaScript/*.js \
        qml/pic/*.svg \
        qml/pic/*.png
android{

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
        android/gradlew.bat

        ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =
# Default rules for deployment.
include(deployment.pri)
