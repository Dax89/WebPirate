#ifndef DOWNLOADITEM_H
#define DOWNLOADITEM_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QTime>
#include <QStringList>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

class DownloadItem: public QObject
{
    Q_OBJECT

    Q_PROPERTY(const QString& speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(const QString& fileName READ fileName NOTIFY fileNameChanged)
    Q_PROPERTY(const QString& lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(bool completed READ completed NOTIFY completedChanged)
    Q_PROPERTY(bool error READ error NOTIFY errorChanged)
    Q_PROPERTY(qint64 progressValue READ progressValue NOTIFY progressValueChanged)
    Q_PROPERTY(qint64 progressTotal READ progressTotal NOTIFY progressTotalChanged)

    public:
        DownloadItem(QObject* parent = 0);
        DownloadItem(const QUrl& url, const QString& filename, QObject* parent = 0);
        const QString& speed() const;
        const QString& fileName() const;
        const QString& lastError() const;
        bool completed() const;
        bool error() const;
        qint64 progressValue() const;
        qint64 progressTotal() const;

    private:
        QString parseFileName(const QUrl& url);
        void checkConflicts(QString& filename, const QString& downloadpath);

    signals:
        void speedChanged();
        void fileNameChanged();
        void completedChanged();
        void errorChanged();
        void lastErrorChanged();
        void progressValueChanged();
        void progressTotalChanged();

    public slots:
        void start();
        void restart();
        void cancel();

    private slots:
        void onNetworkReplyReadyRead();
        void onDownloadError(QNetworkReply::NetworkError);
        void onDownloadFinished(QNetworkReply* reply);
        void onDownloadProgress(qint64 bytesreceived, qint64 bytestotal);

    private:
        static const QString DEFAULT_FILENAME;

    private:
        bool _completed;
        bool _error;
        QUrl _url;
        QUrl _redirectfromurl;
        QUrl _referer;
        QFile _file;
        qint64 _progressvalue;
        qint64 _progresstotal;
        QString _filename;
        QString _downloadspeed;
        QString _lasterror;
        QTime _downloadtime;
        QNetworkAccessManager _networkmanager;
        QNetworkReply* _downloadreply;
};

Q_DECLARE_METATYPE(DownloadItem*)

#endif // DOWNLOADITEM_H
