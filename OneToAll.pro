TEMPLATE = app

QT += qml quick widgets svg

SOURCES += main.cpp \
    src/UserData.cpp

HEADERS += \
    src/UserData.h

INCLUDEPATH += src

RESOURCES += Android.qrc \
    OneToAll.qrc

TRANSLATIONS += i18n/onetoall_zh.ts

debug{
    OTHER_FILES += \
        qml/JavaScript/*.js \
        qml/pic/*.svg \
        qml/pic/*.png
}

android{
    message(andriod bulid)
    debug{
        OTHER_FILES += \
            qml/Android/*.qml \
            qml/Android/BaseComponent/*.qml \
            qml/Android/Delegate/*.qml \
            qml/Android/Dialog/*.qml
        message(andriod debug build)
    }

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

include(deployment.pri)

