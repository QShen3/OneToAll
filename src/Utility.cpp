#include <QThread>
#include <QDebug>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
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
    imageFlag = false;
#endif
}
Utility::~Utility()
{
    disconnect();
    if (!thread.isNull()){
        thread->terminate();
        thread->wait();
        androidImageSelecter->deleteLater();
    }
}

Utility::PlatformType Utility::platformType() const
{
    return m_platformType;
}

QString Utility::selectImage()
{
#ifdef Q_OS_ANDROID
    if(thread.isNull()){
        thread = new QThread(this);
        androidImageSelecter = new AndroidImageSelecter;
        androidImageSelecter->moveToThread(thread);
        connect(this,SIGNAL(startSelectImage(Utility*)),androidImageSelecter,SLOT(start(Utility*)));
        thread->start();
    }
    imageFlag = false;
    emit startSelectImage(this);

    while (true) {

        while (imageFlag) {
            qDebug()<<imageUrl;
            return imageUrl;
        }

        sleep(1);
        //qDebug()<<imageFlag;
    }
    //return "temple";
#endif
}

#ifdef Q_OS_ANDROID

class ResultReceiver: public QAndroidActivityResultReceiver
{
public:
    ResultReceiver(Utility* arg){
        utility = arg;
    }

    void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data){
        Q_UNUSED(data);
        qDebug()<<"here3";
        if(receiverRequestCode == 1){
            if(resultCode == -1){
                qDebug()<<utility->imageFlag;
                utility->imageFlag = true;
                utility->imageUrl = "Test";
            }
            else{
                //some code here
            }
        }
    }
private:
    Utility* utility;
};

AndroidImageSelecter::AndroidImageSelecter(QObject *parent) : QObject(parent)
{
}

AndroidImageSelecter::~AndroidImageSelecter()
{
}

void AndroidImageSelecter::start(Utility* utility)
{
    QAndroidJniEnvironment env;
    ResultReceiver *receiver = new ResultReceiver(utility);

    QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod(
                "com/qshen/onetoall/ImagePicker",
                "createChoosePhotoIntent",
                "()Landroid/content/Intent;" );

    QtAndroid::startActivity( intent, 1, receiver );


    if(env->ExceptionCheck()){
        qDebug()<<"erro";
        env->ExceptionClear();
    }
}


#endif
