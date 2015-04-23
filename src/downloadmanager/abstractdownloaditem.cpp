#include "abstractdownloaditem.h"

AbstractDownloadItem::AbstractDownloadItem(QObject *parent): QObject(parent), _completed(false), _error(false), _bytesreceived(0), _progressvalue(0), _progresstotal(0)
{
    this->_downloadpath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    this->_downloadtimer.setInterval(1000);

    connect(&this->_downloadtimer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    connect(this, SIGNAL(completedChanged()), this, SLOT(stopTimer()));
    connect(this, SIGNAL(errorChanged()), this, SLOT(stopTimer()));
}

AbstractDownloadItem::AbstractDownloadItem(const QUrl &url, QObject *parent): QObject(parent), _url(url), _completed(false), _error(false), _bytesreceived(0), _progressvalue(0), _progresstotal(0)
{
    this->_downloadpath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    this->_downloadtimer.setInterval(1000);

    connect(&this->_downloadtimer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    connect(this, SIGNAL(completedChanged()), this, SLOT(stopTimer()));
    connect(this, SIGNAL(errorChanged()), this, SLOT(stopTimer()));
}

const QUrl &AbstractDownloadItem::url() const
{
    return this->_url;
}

bool AbstractDownloadItem::completed() const
{
    return this->_completed;
}

bool AbstractDownloadItem::error() const
{
    return this->_error;
}

qint64 AbstractDownloadItem::progressValue() const
{
    return this->_progressvalue;
}

qint64 AbstractDownloadItem::progressTotal() const
{
    return this->_progresstotal;
}

const QString &AbstractDownloadItem::fileName() const
{
    return this->_filename;
}

const QString &AbstractDownloadItem::speed() const
{
    return this->_speed;
}

const QString &AbstractDownloadItem::lastError() const
{
    return this->_lasterror;
}

const QString &AbstractDownloadItem::downloadPath() const
{
    return this->_downloadpath;
}

QString AbstractDownloadItem::completePath() const
{
    return QString("%1%2%3").arg(this->downloadPath(), QDir::separator(), this->fileName());
}

void AbstractDownloadItem::adjust(QString &filename)
{
    QRegExp regex("[/\\\\?%*:|\"<> \\t]+");
    filename.replace(regex, "_");
}

void AbstractDownloadItem::checkConflicts(QString &filename)
{
    QDir dir(this->_downloadpath);

    if(!dir.exists(filename))
        return;

    uint i = 0;
    QFileInfo fi(filename);

    while(dir.exists(filename))
    {
        i++;
        filename = QString("%1 (%2).%3").arg(fi.completeBaseName()).arg(i).arg(fi.suffix());
    }
}

void AbstractDownloadItem::setUrl(const QUrl &url)
{
    if(this->_url == url)
        return;

    this->_url = url;
    emit urlChanged();
}

void AbstractDownloadItem::setCompleted(bool b)
{
    if(this->_completed == b)
        return;

    this->_completed = b;
    emit completedChanged();
}

void AbstractDownloadItem::setError(bool b)
{
    if(this->_error == b)
        return;

    this->_error = b;
    emit errorChanged();
}

void AbstractDownloadItem::setProgressValue(qint64 progressvalue)
{
    if(this->_progressvalue == progressvalue)
        return;

    this->_progressvalue = progressvalue;
    emit progressValueChanged();
}

void AbstractDownloadItem::setProgressTotal(qint64 progresstotal)
{
    if(this->_progresstotal == progresstotal)
        return;

    this->_progresstotal = progresstotal;
    emit progressTotalChanged();
}

void AbstractDownloadItem::setFileName(const QString &filename)
{
    if(!QString::compare(this->_filename, filename))
        return;

    this->_filename = filename;
    this->adjust(this->_filename);
    this->checkConflicts(this->_filename);

    emit fileNameChanged();
}

void AbstractDownloadItem::setSpeed(const QString &speed)
{
    if(!QString::compare(this->_speed, speed))
        return;

    this->_speed = speed;
    emit speedChanged();
}

void AbstractDownloadItem::onTimeout()
{
    double speed = this->_bytesreceived;

    if(speed < 1024)
        this->setSpeed(QString("%1 B/s").arg(speed, 3, 'f', 1));
    else if(speed < (1024 * 1024))
        this->setSpeed(QString("%1 kB/s").arg(speed / 1024, 3, 'f', 1));
    else
        this->setSpeed(QString("%1 MB/s").arg(speed / (1024 * 1024), 3, 'f', 1));

    this->_bytesreceived = 0;
}

void AbstractDownloadItem::stopTimer()
{
    if(this->_completed || this->_error)
        this->_downloadtimer.stop();
}

void AbstractDownloadItem::setLastError(const QString &lasterror)
{
    if(!QString::compare(this->_lasterror, lasterror))
        return;

    this->_lasterror = lasterror;
    emit lastErrorChanged();
}

void AbstractDownloadItem::updateBytesReceived(qint64 bytesreceived)
{
    this->_bytesreceived += bytesreceived;
}

void AbstractDownloadItem::start()
{
    this->_bytesreceived = 0;
    this->_downloadtimer.start();

    this->setCompleted(false);
    this->setError(false);
    this->setLastError(QString());
}

void AbstractDownloadItem::cancel()
{
    this->setCompleted(true);
}
