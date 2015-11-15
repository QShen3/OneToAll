#ifndef HTTPREQUEST
#define HTTPREQUEST
#include <QObject>
#include <QtDeclarative>
#if(QT_VERSION<0x050000)
#include <Qurl>
#endif

class QNetworkAccessManager;
class QNetworkReply;
class QFile;
class QHttpMultiPart;


class HttpRequest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(RequestStatus status READ status WRITE setStatus NOTIFY statusChanged)
    Q_ENUMS(RequestStatus)
    Q_ENUMS(RequestMethod)

public:
    explicit HttpRequest(QObject *parent = 0);
    ~HttpRequest();

    enum RequestStatus{
        Idle,//初始状态
        Busy//请求中
    };
    enum RequestMethod{
        GET,
        POSTText,
        POSTFile
    };

    void sendRequest(QUrl url, RequestMethod method, QByteArray text = "", QHttpMultiPart *data = NULL);
    void sendTencentRequest(QUrl url, QByteArray data);

    RequestStatus status();
    void setStatus(RequestStatus newStatus);

    Q_INVOKABLE void sendWeiboImage(QString accessToken, QString fileName, QString text);
    Q_INVOKABLE void sendRenrenImage(QString accessToken, QString fileName, QString text);
    Q_INVOKABLE void sendTencentWeiboImage(QString accessToken, QString openid, QString fileName, QString text);

public slots:
    void loadSendWeiboImageResult(QNetworkReply *reply);
    void loadSendRenrenImageResult(QNetworkReply *reply);
    void loadSendTencentWeiboImageResult(QNetworkReply *reply);


signals:
    void statusChanged();

    void sendWeiboImageFinished(QByteArray oritxt);
    void sendRenrenImageFinished(QByteArray oritxt);
    void sendTencentWeiboImageFinished(QByteArray oritxt);
private:
    QNetworkAccessManager *networkManager;

    RequestStatus m_status;

};

class NetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    explicit NetworkAccessManagerFactory();
    virtual QNetworkAccessManager* create(QObject *parent);
};

class NetworkAccessManager : public QNetworkAccessManager
{
    Q_OBJECT
public:
    explicit NetworkAccessManager(QObject *parent=0);
protected:
    QNetworkReply *createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData);
};

#endif // HTTPREQUEST

