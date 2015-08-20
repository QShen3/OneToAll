
#include <QObject>
#include <QPointer>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
class ResultReceiver;
#endif
class Utility : public QObject
{
    Q_OBJECT

    Q_PROPERTY(PlatformType platformType READ platformType)

    Q_ENUMS(PlatformType)
public:
    enum PlatformType{
        Andriod_x86,
        Andriod_armv7
    };

    explicit Utility(QObject *parent = 0);
    ~Utility();

    PlatformType platformType() const;

    Q_INVOKABLE void selectImage();
    Q_INVOKABLE QByteArray getFile(QString url);

signals:
    void selectImageFinished(QString imageUrl);

private:
    PlatformType m_platformType;
#ifdef Q_OS_ANDROID
    ResultReceiver *resultReceiver;
#endif
};

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


