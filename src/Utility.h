
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




