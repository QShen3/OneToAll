#ifndef SIZEMANAGER
#define SIZEMANAGER
#include <QObject>
class QScreen;
class SizeManager : public QObject
{
    Q_OBJECT

public:
    SizeManager();

    Q_INVOKABLE qreal dp( qreal );

private:
    QScreen *screen;
};

#endif // SIZEMANAGER

