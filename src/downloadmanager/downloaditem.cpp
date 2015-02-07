#include "downloaditem.h"

const QString DownloadItem::DEFAULT_FILENAME = "download.html";

DownloadItem::DownloadItem(QObject *parent): QObject(parent), _completed(false)
{

}

DownloadItem::DownloadItem(const QUrl &url, QObject* parent): QObject(parent), _completed(false), _url(url), _progressvalue(0), _progresstotal(0), _downloadreply(NULL)
{
    QString downloadpath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    connect(&this->_networkmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onDownloadFinished(QNetworkReply*)));

    this->_filename = this->parseFileName(url, downloadpath);
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

QString DownloadItem::parseFileName(const QUrl& url, const QString& downloadpath)
{
    QRegExp regex(QRegExp("[_\\d\\w\\-\\. ]+\\.[_\\d\\w\\-\\. ]+"));
    QString filename = url.toString().split('/').last();
    int idx = filename.indexOf(regex);

    if(filename.isEmpty() || (idx == -1))
        filename = DownloadItem::DEFAULT_FILENAME;
    else
        filename = filename.mid(idx, regex.matchedLength());

    this->checkConflicts(filename, downloadpath);
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

    this->_completed = false;
    emit completedChanged();

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
