#ifndef DOWNLOADER
#define DOWNLOADER
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;

class Downloader : public QObject
{
public:
    explicit Downloader(QObject *parent = 0);
    ~Downloader();

    Q_INVOKABLE void append(QString url);
private:
    QNetworkAccessManager *manager;
    QNetworkReply *reply;
};

#endif // DOWNLOADER

