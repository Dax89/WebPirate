#include "downloaditem.h"

DownloadItem::DownloadItem(QObject *parent): QObject(parent), _completed(false)
{

}

DownloadItem::DownloadItem(const QUrl &url, QObject* parent): QObject(parent), _completed(false), _url(url), _progressvalue(0), _progresstotal(0), _downloadreply(NULL)
{
    connect(&this->_neworkmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onDownloadFinished(QNetworkReply*)));

    this->_filename = url.toString().split('/').last();
    this->_file.setFileName(QStandardPaths::writableLocation(QStandardPaths::DownloadLocation) + "/" + this->_filename);
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

bool DownloadItem::completed() const
{
    return this->_completed;
}

qint64 DownloadItem::progressValue() const
{
    return this->_progressvalue;
}

qint64 DownloadItem::progressTotal() const
{
    return this->_progresstotal;
}

void DownloadItem::start()
{
    QNetworkRequest request(this->_url);

    this->_file.open(QFile::WriteOnly | QFile::Truncate);

    if(this->_completed)
        this->_downloadtime.restart();
    else
        this->_downloadtime.start();

    this->_completed = false;
    emit completedChanged();

    this->_downloadreply = this->_neworkmanager.get(request);
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

    emit error(this->_downloadreply->errorString());
}

void DownloadItem::onDownloadFinished(QNetworkReply* reply)
{
    this->_completed = true;
    this->_file.close();

    reply->deleteLater();
    this->_downloadreply = NULL;

    emit completedChanged();
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
