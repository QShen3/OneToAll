#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFile>
#include <QDebug>

#if(QT_VERSION>=0x040800)
#include <QHttpMultiPart>
#endif

#if QT_VERSION < 0x050000
#include <QDesktopServices>
#else
#include <QStandardPaths>
#endif
#include "HttpRequest.h"
HttpRequest::HttpRequest(QObject *parent) : QObject(parent)
{
    networkManager = new QNetworkAccessManager(this);
}
HttpRequest::~HttpRequest()
{
    delete networkManager;
}

void HttpRequest::sendWeiboImage(QString accessToken, QString fileName, QString text)
{
    QUrl url("https://api.weibo.com/2/statuses/upload.json");
    connect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendWeiboImageResult(QNetworkReply*)));

#if(QT_VERSION>=0x040800)
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QHttpPart filePart;
    QHttpPart textPart;
    QHttpPart atPart;

    QFile *file = new QFile(fileName);
    filePart.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("image/jpeg"));
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"pic\"; filename=\"test\""));
    file->open(QIODevice::ReadOnly);
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    textPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"status\""));
    textPart.setBody(text.toUtf8());

    atPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    atPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"access_token\""));
    atPart.setBody(accessToken.toLatin1());

    multiPart->append(filePart);
    multiPart->append(textPart);
    multiPart->append(atPart);
    sendRequest(url,POSTFile,"", multiPart);
#else

    QFile *file = new QFile(fileName);
    file->open(QIODevice::ReadOnly);
    QByteArray data;
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: image/jpeg\r\nContent-Disposition: form-data; name=\"pic\"; filename=\"test.jpg\"\r\n\r\n");
    data.append(file->readAll() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"status\"\r\n\r\n");
    data.append(text.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"access_token\"\r\n\r\n");
    data.append(accessToken.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4--\r\n");
    sendRequest(url, POSTFile, data);
    delete file;
#endif
}
void HttpRequest::loadSendWeiboImageResult(QNetworkReply *reply)
{
    emit sendWeiboImageFinished(reply->readAll());
    disconnect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendWeiboImageResult(QNetworkReply*)));
    setStatus(Idle);
    reply->deleteLater();
    //delete reply;
}

void HttpRequest::sendRenrenImage(QString accessToken, QString fileName, QString text)
{
    QUrl url("https://api.renren.com/v2/photo/upload");
    connect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendRenrenImageResult(QNetworkReply*)));

#if(QT_VERSION>=0x040800)
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QHttpPart filePart;
    QHttpPart textPart;
    QHttpPart atPart;

    QFile *file = new QFile(fileName);
    filePart.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("image/jpeg"));
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"file\"; filename=\"test.jpg\""));
    file->open(QIODevice::ReadOnly);
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    textPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"description\""));
    textPart.setBody(text.toUtf8());

    atPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    atPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"access_token\""));
    atPart.setBody(accessToken.toLatin1());

    multiPart->append(filePart);
    multiPart->append(textPart);
    multiPart->append(atPart);
    sendRequest(url,POSTFile,"", multiPart);
#else
    QFile *file = new QFile(fileName);
    file->open(QIODevice::ReadOnly);
    QByteArray data;
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: image/jpeg\r\nContent-Disposition: form-data; name=\"file\"; filename=\"test.jpg\"\r\n\r\n");
    data.append(file->readAll() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"description\"\r\n\r\n");
    data.append(text.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"access_token\"\r\n\r\n");
    data.append(accessToken.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4--\r\n");
    sendRequest(url, POSTFile, data);
    delete file;
#endif

}
void HttpRequest::loadSendRenrenImageResult(QNetworkReply *reply)
{
    emit sendRenrenImageFinished(reply->readAll());
    disconnect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendRenrenImageResult(QNetworkReply*)));
    setStatus(Idle);
    reply->deleteLater();
    //delete reply;
}

void HttpRequest::sendTencentWeiboImage(QString accessToken, QString openid, QString fileName, QString text)
{
    QUrl url("https://graph.qq.com/t/add_pic_t");
    connect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendTencentWeiboImageResult(QNetworkReply*)));

    QFile *file = new QFile(fileName);
    file->open(QIODevice::ReadOnly);    
    QByteArray data;
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: image/jpeg\r\nContent-Disposition: form-data; name=\"pic\"; filename=\"test.jpg\"\r\n\r\n");
    data.append(file->readAll() + "\r\n");    
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"content\"\r\n\r\n");
    data.append(text.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"access_token\"\r\n\r\n");
    data.append(accessToken.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"oauth_consumer_key\"\r\n\r\n");
    data.append(QByteArray("101258308") + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\r\nContent-Type: text/plain\r\nContent-Disposition: form-data; name=\"openid\"\r\n\r\n");
    data.append(openid.toUtf8() + "\r\n");
    data.append("--boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4--\r\n");
    sendTencentRequest(url, data);

    file->deleteLater();

}
void HttpRequest::loadSendTencentWeiboImageResult(QNetworkReply *reply)
{
    emit sendTencentWeiboImageFinished(reply->readAll());
    disconnect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendTencentWeiboImageResult(QNetworkReply*)));
    setStatus(Idle);
    reply->deleteLater();
}

void HttpRequest::sendRequest(QUrl url, RequestMethod method, QByteArray text, QHttpMultiPart *data)
{
    QNetworkRequest networkRequest(url);
    setStatus(Busy);

    switch (method) {
    case GET:
        networkManager->get(networkRequest);
        break;
    case POSTText:
        networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("multipart/form-data"));

        networkManager->post(networkRequest, text);
        break;
    case POSTFile:
#if(QT_VERSION>=0x040800)
        QNetworkReply *reply = networkManager->post(networkRequest,data);

        data->setParent(reply);
#else
        networkRequest.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("multipart/form-data; boundary=\"boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4\""));
        networkManager->post(networkRequest, text);
#endif
        break;
    }
}

void HttpRequest::sendTencentRequest(QUrl url, QByteArray data)
{
    QNetworkRequest networkRequest(url);
    setStatus(Busy);

    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("multipart/form-data; boundary=boundary_.oOo._MTUwMDc1MzE3Mw==MTg4Mjk1Njk1MzUyMTIwNTY4"));
    networkManager->post(networkRequest, data);
}

HttpRequest::RequestStatus HttpRequest::status()
{
    return m_status;
}

void HttpRequest::setStatus(RequestStatus newStatus)
{
    if(m_status != newStatus){
        m_status = newStatus;
        emit statusChanged();
    }
}

#if(QT_VERSION<0x050000)
NetworkAccessManagerFactory::NetworkAccessManagerFactory() : QDeclarativeNetworkAccessManagerFactory()
#else
NetworkAccessManagerFactory::NetworkAccessManagerFactory() : QQmlNetworkAccessManagerFactory()
#endif
{
}

QNetworkAccessManager* NetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager* manager = new NetworkAccessManager(parent);

    QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);
#if(QT_VERSION<0x050000)
    QString dataPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
#else
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
#endif
    diskCache->setCacheDirectory(dataPath);
    diskCache->setMaximumCacheSize(3*1024*1024);
    manager->setCache(diskCache);

    return manager;
}

NetworkAccessManager::NetworkAccessManager(QObject *parent) : QNetworkAccessManager(parent)
{
}

QNetworkReply *NetworkAccessManager::createRequest(Operation op,
                                                   const QNetworkRequest &request,
                                                   QIODevice *outgoingData)
{
    QNetworkRequest req(request);
#if defined(Q_OS_SYMBIAN)
    req.setRawHeader("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)");
#endif
    req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    QNetworkReply *reply = QNetworkAccessManager::createRequest(op, req, outgoingData);
    return reply;
}
