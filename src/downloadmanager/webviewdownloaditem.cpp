#include "webviewdownloaditem.h"

WebViewDownloadItem::WebViewDownloadItem(QObject *downloaditem, QObject *parent): AbstractDownloadItem(QUrl(), parent), _downloaditem(downloaditem)
{
    this->setUrl(this->getProperty(downloaditem, "url").toUrl());
    this->setFileName(this->getProperty(downloaditem, "suggestedFilename").toString());
    this->setProgressTotal(this->getProperty(downloaditem, "expectedContentLength").value<qint64>());
    this->setProperty(downloaditem, "destinationPath", QString("%1%2%3").arg(this->downloadPath(), QDir::separator(), this->fileName()));

    connect(downloaditem, SIGNAL(totalBytesReceivedChanged(quint64)), this, SLOT(onByteReceivedChanged(quint64)));
    connect(downloaditem, SIGNAL(succeeded()), this, SLOT(onDownloadSucceeded()));
    connect(downloaditem, SIGNAL(failed(QWebDownloadItem::DownloadError,const QUrl&,const QString&)), this, SLOT(onDownloadFailed(QWebDownloadItem::DownloadError,const QUrl&,const QString&)));
}

QVariant WebViewDownloadItem::getProperty(const QObject *obj, const char *name) const
{
    const QMetaObject* metaobj = obj->metaObject();
    return metaobj->property(metaobj->indexOfProperty(name)).read(obj);
}

bool WebViewDownloadItem::setProperty(QObject *obj, const char *name, QVariant value) const
{
    const QMetaObject* metaobj = obj->metaObject();
    return metaobj->property(metaobj->indexOfProperty(name)).write(obj, value);
}

void WebViewDownloadItem::removeFile()
{
    QString completepath = this->completePath();

    if(QFile::exists(completepath))
        QFile::remove(completepath);
}

void WebViewDownloadItem::start()
{
    AbstractDownloadItem::start();

    const QMetaObject* metaobj = this->_downloaditem->metaObject();
    metaobj->invokeMethod(this->_downloaditem, "start");
}

void WebViewDownloadItem::cancel()
{
    const QMetaObject* metaobj = this->_downloaditem->metaObject();
    metaobj->invokeMethod(this->_downloaditem, "cancel");

    AbstractDownloadItem::cancel();
    this->removeFile();
}

void WebViewDownloadItem::onByteReceivedChanged(quint64 bytesreceived)
{    
    this->setProgressValue(this->progressValue() + bytesreceived);
    this->updateBytesReceived(bytesreceived);
}

void WebViewDownloadItem::onDownloadSucceeded()
{
    this->setCompleted(true);
    this->setError(false);
    this->setLastError(QString());

    emit downloadCompleted(this->fileName());
}

void WebViewDownloadItem::onDownloadFailed(QWebDownloadItem::DownloadError, const QUrl&, const QString &description)
{
    this->setCompleted(false);
    this->setError(true);
    this->setLastError(description);    
    this->removeFile();

    emit downloadFailed(this->fileName());
}
