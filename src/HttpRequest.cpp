#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QHttpMultiPart>
#include <QFile>
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
    textPart.setBody(text.toLatin1());

    atPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    atPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"access_token\""));
    atPart.setBody(accessToken.toLatin1());

    multiPart->append(filePart);
    multiPart->append(textPart);
    multiPart->append(atPart);
    sendRequest(url,POSTFile,"", multiPart);
}
void HttpRequest::loadSendWeiboImageResult(QNetworkReply *reply)
{
    emit sendWeiboImageFinished(reply->readAll());
    disconnect(networkManager,SIGNAL(finished(QNetworkReply*)),this,SLOT(loadSendWeiboImageResult(QNetworkReply*)));
    setStatus(Idle);
    delete reply;
}

void HttpRequest::sendRequest(QUrl url, RequestMethod method, QString text, QHttpMultiPart *data)
{
    QNetworkRequest networkRequest(url);
    setStatus(Busy);

    switch (method) {
    case GET:
        networkManager->get(networkRequest);
        break;
    case POSTText:
        networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/x-www-form-urlencoded"));

        networkManager->post(networkRequest,text.toLatin1());
        break;
    case POSTFile:

        QNetworkReply *reply = networkManager->post(networkRequest,data);

        data->setParent(reply);
        break;
    }
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
