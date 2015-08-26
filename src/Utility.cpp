#include <QThread>
#include <QDebug>
#include <QFile>
#ifdef Q_OS_ANDROID
#include <unistd.h>
#endif
#include "Utility.h"

#ifdef Q_OS_ANDROID
class ResultReceiver: public QAndroidActivityResultReceiver
{
public:
    ResultReceiver(Utility *arg)
    {
        utility = arg;
    }

    void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data)
    {
        if(receiverRequestCode == 1){
            if(resultCode == -1){
                QAndroidJniEnvironment env;

                QAndroidJniObject path= QAndroidJniObject::callStaticObjectMethod(
                            "com/qshen/onetoall/ImagePicker",
                            "getUrl",
                            "(Landroid/content/Intent;)Ljava/lang/String;",
                            data.object<jobject>());

                emit utility->selectImageFinished(path.toString());

                if(env->ExceptionCheck()){
                    qDebug()<<"erro";
                    env->ExceptionDescribe();
                    env->ExceptionClear();
                }
            }
            else{
                qDebug()<<"erro";
            }
        }
    }

private:
    Utility *utility;

};
#endif



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

QByteArray Utility::getFile(QString url)
{
    QFile file(url);
    if(!file.open(QIODevice::ReadOnly)){
        qDebug() << "erro";
    }
    return file.readAll();
}



