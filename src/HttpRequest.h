#ifndef HTTPREQUEST
#define HTTPREQUEST
#include <QObject>

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

    void sendRequest(QUrl url, RequestMethod method, QString text = "", QHttpMultiPart *data = NULL);

    RequestStatus status();
    void setStatus(RequestStatus newStatus);

    Q_INVOKABLE void sendWeiboImage(QString accessToken, QString fileName, QString text);
   // Q_INVOKABLE void sendRenRenImage(QString fileName, QString text);

public slots:
    void loadSendWeiboImageResult(QNetworkReply *reply);


signals:
    void statusChanged();

    void sendWeiboImageFinished(QByteArray oritxt);
private:
    QNetworkAccessManager *networkManager;

    RequestStatus m_status;

};

#endif // HTTPREQUEST

