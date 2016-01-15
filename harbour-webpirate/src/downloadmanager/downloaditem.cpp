#include "downloaditem.h"

const QString DownloadItem::DEFAULT_FILENAME = "download.html";

DownloadItem::DownloadItem(QObject *parent): AbstractDownloadItem(parent), _downloadreply(NULL)
{

}

DownloadItem::DownloadItem(const QUrl &url, const QString &filename, QObject* parent): AbstractDownloadItem(url, parent), _downloadreply(NULL)
{
    connect(&this->_networkmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onDownloadFinished(QNetworkReply*)));

    this->setFileName((filename.isEmpty() ? this->parseFileName(url) : filename));
    this->_file.setFileName(QString("%1%2%3").arg(this->downloadPath(), QDir::separator(), this->fileName()));
}

QString DownloadItem::parseFileName(const QUrl& url)
{
    QRegExp regex(QRegExp("[_\\d\\w\\-\\. ]+\\.[_\\d\\w\\-\\. ]+"));
    QString filename = url.toString().split('/').last();
    int idx = filename.indexOf(regex);

    if(filename.isEmpty() || (idx == -1))
        filename = DownloadItem::DEFAULT_FILENAME;
    else
        filename = filename.mid(idx, regex.matchedLength());

    return filename;
}

void DownloadItem::start()
{
    QNetworkRequest request(this->url());
    this->_file.open(QFile::WriteOnly | QFile::Truncate);

    AbstractDownloadItem::start();

    this->_downloadreply = this->_networkmanager.get(request);
    connect(this->_downloadreply, SIGNAL(readyRead()), this, SLOT(onNetworkReplyReadyRead()));
    connect(this->_downloadreply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(onDownloadProgress(qint64,qint64)));
    connect(this->_downloadreply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onDownloadError(QNetworkReply::NetworkError)));
}

void DownloadItem::cancel()
{
    if(this->_downloadreply)
        this->_downloadreply->abort();

    if(this->_file.isOpen())
        this->_file.close();

    if(this->_file.exists())
        this->_file.remove();

    AbstractDownloadItem::cancel();
}

void DownloadItem::onNetworkReplyReadyRead()
{
    this->_file.write(this->_downloadreply->readAll());
}

void DownloadItem::onDownloadError(QNetworkReply::NetworkError)
{
    this->_file.close();
    this->_file.remove();

    this->setError(true);
    this->setLastError(this->_downloadreply->errorString());

    emit downloadFailed(this->fileName());
}

void DownloadItem::onDownloadFinished(QNetworkReply* reply)
{
    int statuscode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    this->_file.close();

    if(statuscode == 302) /* Manage Redirects */
    {
        this->_file.remove(); /* Delete Junk File */
        QUrl redirecturl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();

        if(redirecturl.isValid() && (redirecturl != this->url())) /* Avoid Fake/Redirect Loop */
        {
            this->_redirectfromurl = this->url();
            this->setUrl(redirecturl);

            reply->deleteLater();
            this->_downloadreply = NULL;
            this->start();
        }
        else
        {
            this->setError(true);
            this->setCompleted(false);
            this->setLastError(tr("Redirect Loop"));
        }
    }
    else
    {
        if(statuscode == 200)
            this->setCompleted(true);
        else
        {
            this->setError(true);
            this->setLastError(reply->errorString());
        }

        reply->deleteLater();
        this->_downloadreply = NULL;
    }

    if(!this->error())
        emit downloadCompleted(this->fileName());
}

void DownloadItem::onDownloadProgress(qint64 bytesreceived, qint64 bytestotal)
{
    if(this->progressTotal() != bytestotal)
        this->setProgressTotal(bytestotal);

    this->updateBytesReceived(bytesreceived - this->progressValue());
    this->setProgressValue(bytesreceived);
}
