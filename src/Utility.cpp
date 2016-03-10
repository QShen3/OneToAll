#include <QThread>
#include <QDebug>
#include <QFile>
#include <QDir>
#ifdef Q_OS_ANDROID
#include <unistd.h>
#elif defined(Q_OS_SYMBIAN)
#include <mgfetch.h>                //select image
#include <NewFileServiceClient.h>   //cameral
#include <AiwServiceHandler.h>      //..
#include <AiwCommon.hrh>            //..
#include <AiwGenericParam.hrh>
#elif defined(Q_OS_HARMATTAN)
#include <QDBusConnection>
#define CAMERA_SERVICE "com.nokia.maemo.CameraService"
#define CAMERA_INTERFACE "com.nokia.maemo.meegotouch.CameraInterface"
#include <videosuiteinterface.h>
#include <MNotification>
#include <MRemoteAction>
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
        if(resultCode != -1){
            qDebug()<<"erro";
            return;
        }
        if(receiverRequestCode == 1){
            QAndroidJniEnvironment env;

            QAndroidJniObject path= QAndroidJniObject::callStaticObjectMethod(
                        "com/qshen/onetoall/ImagePicker",
                        "getUrl",
                        "(Landroid/content/Intent;)Ljava/lang/String;",
                        data.object<jobject>());

            //qDebug()<<path.toString();

            emit utility->selectImageFinished(path.toString());

            if(env->ExceptionCheck()){
                qDebug()<<"erro";
                env->ExceptionDescribe();
                env->ExceptionClear();
            }

        }
        else if (receiverRequestCode == 2) {
            QAndroidJniEnvironment env;

            emit utility->selectImageFinished("/storage/emulated/0/DCIM/Camera/" + (utility->imageName).toString());

            if(env->ExceptionCheck()){
                qDebug()<<"erro";
                env->ExceptionDescribe();
                env->ExceptionClear();
            }
        }
    }

private:
    Utility *utility;

};
#elif defined(Q_OS_HARMATTAN)
void Utility::captureCanceled(const QString &mode)
{
    Q_UNUSED(mode)
    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                   "captureCanceled", this, SLOT(captureCanceled(QString)));

    bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                   "captureCompleted", this, SLOT(captureCompleted(QString,QString)));
}
void Utility::captureCompleted(const QString &mode, const QString &fileName)
{
    Q_UNUSED(mode)
    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                   "captureCanceled", this, SLOT(captureCanceled(QString)));

    bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                   "captureCompleted", this, SLOT(captureCompleted(QString,QString)));
    emit selectImageFinished(fileName);
}

#endif



Utility::Utility(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID
    #ifdef Q_PROCESSOR_X86
    m_platformType = Andriod_x86;       //0
    #else
    m_platformType = Andriod_armv7;     //1
    #endif
    resultReceiver = new ResultReceiver(this);
#elif defined(Q_OS_SYMBIAN)
    m_platformType = Symbian3;          //2
#elif defined(Q_OS_HARMATTAN) | defined(Q_WS_SIMULATOR)
    m_platformType = Meego;             //3
#elif defined(Q_OS_WIN32)
    m_platformType = Win32;             //4
#endif
}
Utility::~Utility()
{
    disconnect();
#ifdef Q_OS_ANDROID
    delete resultReceiver;
#endif

}

Utility::PlatformType Utility::platformType() const
{
    return m_platformType;
}

QString Utility::getLocale()
{
    return QLocale::system().name();
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
#elif defined(Q_OS_SYMBIAN)
    QString result;
    CDesCArray* fileNames = new(ELeave)CDesCArrayFlat(1);
    CleanupStack::PushL(fileNames);
    if (MGFetch::RunL(*fileNames, EImageFile, EFalse)){
        TPtrC fileName = fileNames->MdcaPoint(0);
        result = QString((QChar*) fileName.Ptr(), fileName.Length());
    }
    CleanupStack::PopAndDestroy(fileNames);
    qDebug() << result;
    emit selectImageFinished(QDir::fromNativeSeparators(result));
#elif defined(Q_WS_SIMULATOR)
    emit selectImageFinished("E:/Image/83419e2f070828384964f455bb99a9014d08f1c0.jpg");
#elif defined(Q_OS_WIN32)

#endif
}

void Utility::captureImage()
{
#ifdef Q_OS_ANDROID
    imageName = QAndroidJniObject::fromString((QDateTime::currentDateTime()).toString("yyyyMMddHHmmss")+".jpg");

    if(resultReceiver == NULL)
        resultReceiver = new ResultReceiver(this);
    QAndroidJniEnvironment env;

    QAndroidJniObject intent = QAndroidJniObject::callStaticObjectMethod(
                "com/qshen/onetoall/ImagePicker",
                "createCaptureImageIntent",
                "(Ljava/lang/String;)Landroid/content/Intent;",
                imageName.object<jstring>());

    if(env->ExceptionCheck()){
        qDebug()<<"erro";
        env->ExceptionClear();
    }
    QtAndroid::startActivity( intent, 2, resultReceiver );
#elif defined(Q_OS_SYMBIAN)
    CNewFileServiceClient* fileClient = NewFileServiceFactory::NewClientL();
    CleanupStack::PushL(fileClient);

    CDesCArray* fileNames = new (ELeave) CDesCArrayFlat(1);
    CleanupStack::PushL(fileNames);

    CAiwGenericParamList* paramList = CAiwGenericParamList::NewLC();

    TAiwVariant variant(EFalse);
#ifdef Q_OS_S60V5
    TAiwGenericParam param1(170, variant);
#else
    TAiwGenericParam param1(EGenericParamMMSSizeLimit, variant);
#endif
    paramList->AppendL( param1 );

    TSize resolution = TSize(1600, 1200);
    TPckgBuf<TSize> buffer( resolution );
    TAiwVariant resolutionVariant( buffer );
#ifdef Q_OS_S60V5
    TAiwGenericParam param( 171, resolutionVariant );
#else
    TAiwGenericParam param( EGenericParamResolution, resolutionVariant );
#endif
    paramList->AppendL( param );

    const TUid KUidCamera = { 0x101F857A }; // Camera UID for S60 5th edition

    TBool result = fileClient->NewFileL( KUidCamera, *fileNames, paramList,
                                         ENewFileServiceImage, EFalse );

    QString ret;

    if (result) {
        TPtrC fileName=fileNames->MdcaPoint(0);
        ret = QString((QChar*) fileName.Ptr(), fileName.Length());
    }

    CleanupStack::PopAndDestroy(3);

    //qDebug() << ret;
    emit selectImageFinished(ret);
    //return ret;
#elif defined(Q_OS_HARMATTAN)
    QDBusConnection bus = QDBusConnection::sessionBus();
    bus.connect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                "captureCanceled", this, SLOT(captureCanceled(QString)));
    bus.connect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                "captureCompleted", this, SLOT(captureCompleted(QString,QString)));
    QDBusMessage message = QDBusMessage::createMethodCall(CAMERA_SERVICE, "/", CAMERA_INTERFACE, "showCamera");
    QVariantList arguments;
    uint someVar = 0;
    arguments << someVar << "" << "still-capture" << true;
    message.setArguments(arguments);
    QDBusMessage reply = bus.call(message);
    if (reply.type() == QDBusMessage::ErrorMessage){
        bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                       "captureCanceled", this, SLOT(captureCanceled(QString)));

        bus.disconnect(CAMERA_SERVICE, "/", CAMERA_INTERFACE,
                       "captureCompleted", this, SLOT(captureCompleted(QString,QString)));
    }
#elif defined(Q_OS_WIN32)

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



