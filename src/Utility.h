#ifndef UTILITY
#define UTILITY
#include <QObject>
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

private:
    PlatformType m_platformType;
};

#endif // UTILITY

