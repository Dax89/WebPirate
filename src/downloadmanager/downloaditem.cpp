#include "downloaditem.h"

const QString DownloadItem::DEFAULT_FILENAME = "download.html";

DownloadItem::DownloadItem(QObject *parent): QObject(parent), _completed(false), _error(false)
{

}

DownloadItem::DownloadItem(const QUrl &url, const QString &filename, QObject* parent): QObject(parent), _completed(false), _url(url), _progressvalue(0), _progresstotal(0), _downloadreply(NULL)
{
    QString downloadpath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    connect(&this->_networkmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onDownloadFinished(QNetworkReply*)));

    if(filename.isEmpty())
        this->_filename = this->parseFileName(url);
    else
        this->_filename = filename;

    this->checkConflicts(this->_filename, downloadpath);

    qDebug() << QString("%1%2%3").arg(downloadpath, QDir::separator(), this->_filename);

    this->_file.setFileName(QString("%1%2%3").arg(downloadpath, QDir::separator(), this->_filename));
    emit fileNameChanged();
}

const QString &DownloadItem::speed() const
{
    return this->_downloadspeed;
}

const QString &DownloadItem::fileName() const
{
    return this->_filename;
}

const QString &DownloadItem::lastError() const
{
    return this->_lasterror;
}

bool DownloadItem::completed() const
{
    return this->_completed;
}

bool DownloadItem::error() const
{
    return this->_error;
}

qint64 DownloadItem::progressValue() const
{
    return this->_progressvalue;
}

qint64 DownloadItem::progressTotal() const
{
    return this->_progresstotal;
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

void DownloadItem::checkConflicts(QString& filename, const QString& downloadpath)
{
    QDir dir(downloadpath);

    if(!dir.exists(filename))
        return;

    uint i = 0;
    QFileInfo fi(filename);

    while(dir.exists(filename))
    {
        i++;
        filename = QString("%1 (%2).%3").arg(fi.baseName()).arg(i).arg(fi.completeSuffix());
    }
}

void DownloadItem::start()
{
    QNetworkRequest request(this->_url);
    this->_file.open(QFile::WriteOnly | QFile::Truncate);

    if(this->_completed)
        this->_downloadtime.restart();
    else
        this->_downloadtime.start();

    this->_error = false;
    this->_lasterror.clear();
    this->_completed = false;

    emit completedChanged();
    emit errorChanged();
    emit lastErrorChanged();

    this->_downloadreply = this->_networkmanager.get(request);
    connect(this->_downloadreply, SIGNAL(readyRead()), this, SLOT(onNetworkReplyReadyRead()));
    connect(this->_downloadreply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(onDownloadProgress(qint64,qint64)));
    connect(this->_downloadreply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onDownloadError(QNetworkReply::NetworkError)));
}

void DownloadItem::restart()
{
    this->cancel();
    this->start();
}

void DownloadItem::cancel()
{
    this->_completed = true;

    if(this->_downloadreply)
        this->_downloadreply->abort();

    if(this->_file.isOpen())
        this->_file.close();

    if(this->_file.exists())
        this->_file.remove();

    emit completedChanged();
}

void DownloadItem::onNetworkReplyReadyRead()
{
    this->_file.write(this->_downloadreply->readAll());
}

void DownloadItem::onDownloadError(QNetworkReply::NetworkError)
{
    this->_file.close();
    this->_file.remove();

    this->_error = true;
    this->_lasterror = this->_downloadreply->errorString();

    emit errorChanged();
    emit lastErrorChanged();
}

void DownloadItem::onDownloadFinished(QNetworkReply* reply)
{
    int statuscode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    this->_file.close();

    qDebug() << statuscode;

    if(statuscode == 302) /* Manage Redirects */
    {
        this->_file.remove(); /* Delete Junk File */
        QUrl redirecturl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();

        if(redirecturl.isValid() && (redirecturl != this->_url)) /* Avoid Fake/Redirect Loop */
        {
            this->_redirectfromurl = this->_url;
            this->_url = redirecturl;

            reply->deleteLater();
            this->_downloadreply = NULL;
            this->start();
        }
        else
        {
            this->_error = true;
            this->_completed = false;
            this->_lasterror = tr("Redirect Loop");

            emit completedChanged();
            emit errorChanged();
            emit lastErrorChanged();
        }
    }
    else
    {
        if(statuscode == 200)
        {
            this->_completed = true;
            emit completedChanged();
        }
        else
        {
            this->_error = true;
            this->_lasterror = reply->errorString();

            emit errorChanged();
            emit lastErrorChanged();
        }

        reply->deleteLater();
        this->_downloadreply = NULL;

    }
}

void DownloadItem::onDownloadProgress(qint64 bytesreceived, qint64 bytestotal)
{
    this->_progressvalue = bytesreceived;

    if(this->_progresstotal != bytestotal)
    {
        this->_progresstotal = bytestotal;
        emit progressTotalChanged();
    }

    double speed = bytesreceived * 1000.0 / this->_downloadtime.elapsed();

    if(speed < 1024)
        this->_downloadspeed = QString("%1 B/s").arg(speed, 3, 'f', 1);
    else if(speed < (1024 * 1024))
        this->_downloadspeed = QString("%1 kB/s").arg(speed / 1024, 3, 'f', 1);
    else
        this->_downloadspeed = QString("%1 MB/s").arg(speed / (1024 * 1024), 3, 'f', 1);

    emit speedChanged();
    emit progressValueChanged();
}
