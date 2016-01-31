
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

    friend class ResultReceiver;
public:   
    enum PlatformType{
        Andriod_x86,
        Andriod_armv7,
        Symbian3,
        Meego,
        Win32
    };

    explicit Utility(QObject *parent = 0);
    ~Utility();

    PlatformType platformType() const;

    Q_INVOKABLE QString getLocale();

    Q_INVOKABLE void selectImage();
    Q_INVOKABLE void captureImage();
    Q_INVOKABLE QByteArray getFile(QString url);

signals:
    void selectImageFinished(QString imageUrl);

private slots:
#ifdef Q_OS_HARMATTAN
    void captureCanceled(const QString &mode);
    void captureCompleted(const QString &mode, const QString &fileName);
#endif

private:
    PlatformType m_platformType;
#ifdef Q_OS_ANDROID
    ResultReceiver *resultReceiver;

    QAndroidJniObject imageName;
#endif
};




