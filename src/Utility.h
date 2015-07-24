
#include <QObject>
#include <QPointer>
class AndroidImageSelecter;
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

    Q_INVOKABLE QString selectImage();

private:
    PlatformType m_platformType;


public:
    bool imageFlag;
    QString imageUrl;

signals:
    void startSelectImage(Utility*);

private:
    QPointer<QThread> thread;
    QPointer<AndroidImageSelecter> androidImageSelecter;


};

class AndroidImageSelecter : public QObject
{
    Q_OBJECT

public:
    explicit AndroidImageSelecter(QObject *parent = 0);
    ~AndroidImageSelecter();

public slots:
    void start(Utility*);

};



