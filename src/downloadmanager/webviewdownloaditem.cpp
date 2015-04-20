#include "webviewdownloaditem.h"

WebViewDownloadItem::WebViewDownloadItem(QWebDownloadItem *downloaditem, QObject *parent): AbstractDownloadItem(downloaditem->url(), parent), _downloaditem(downloaditem)
{
    this->setFileName(downloaditem->suggestedFilename());
    this->setProgressTotal(downloaditem->expectedContentLength());
    downloaditem->setDestinationPath(QString("%1%2%3").arg(this->downloadPath(), QDir::separator(), this->fileName()));

    connect(downloaditem, SIGNAL(totalBytesReceivedChanged(quint64)), this, SLOT(onByteReceivedChanged(quint64)));
    connect(downloaditem, SIGNAL(succeeded()), this, SLOT(onDownloadSucceeded()));
    connect(downloaditem, SIGNAL(failed(QWebDownloadItem::DownloadError,const QUrl&,const QString&)), this, SLOT(onDownloadFailed(QWebDownloadItem::DownloadError,const QUrl&,const QString&)));
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
    this->_downloaditem->start();
}

void WebViewDownloadItem::cancel()
{
    this->_downloaditem->cancel();
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
}

void WebViewDownloadItem::onDownloadFailed(QWebDownloadItem::DownloadError, const QUrl&, const QString &description)
{
    this->setCompleted(false);
    this->setError(true);
    this->setLastError(description);    
    this->removeFile();
}
