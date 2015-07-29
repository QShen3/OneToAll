#include <QThread>
#include <QDebug>
#ifdef Q_OS_ANDROID
#include <unistd.h>
#endif
#include "Utility.h"

Utility::Utility(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID

#ifdef Q_PROCESSOR_X86
    m_platformType = Andriod_x86;
#else
    m_platformType = Andriod_armv7;
#endif
    resultReceiver = new ResultReceiver(this);
#endif
}
Utility::~Utility()
{
    disconnect();
    delete resultReceiver;

}

Utility::PlatformType Utility::platformType() const
{
    return m_platformType;
}

void Utility::selectImage()
{
#ifdef Q_OS_ANDROID
    if(resultReceiver == NULL)
        resultReceiver = new ResultReceiver(this);
    QAndroidJniEnvironment env;
    QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod(
                "com/qshen/onetoall/ImagePicker",
                "createChoosePhotoIntent",
                "()Landroid/content/Intent;" );

    if(env->ExceptionCheck()){
        qDebug()<<"erro";
        env->ExceptionClear();
    }
    QtAndroid::startActivity( intent, 1, resultReceiver );

#endif
}

