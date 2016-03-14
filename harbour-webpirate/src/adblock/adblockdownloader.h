#ifndef ADBLOCKDOWNLOADER_H
#define ADBLOCKDOWNLOADER_H

#include <QObject>
#include <QStandardPaths>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include "adblockmanager.h"

class AdBlockDownloader: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool downloading READ downloading NOTIFY downloadingChanged)
    Q_PROPERTY(qint64 progressValue READ progressValue NOTIFY progressValueChanged)
    Q_PROPERTY(qint64 progressTotal READ progressTotal NOTIFY progressTotalChanged)

    private:
        enum DownloadType { Undefined = 0, Filters = 1, Hosts = 2 };

    public:
        explicit AdBlockDownloader(QObject *parent = 0);
        bool downloading() const;
        qint64 progressValue() const;
        qint64 progressTotal() const;

    private:
        void downloadFile(const QString &path, const QString& filename, const QString &localfile);

    signals:
        void progressTotalChanged();
        void progressValueChanged();
        void connectionStarted();
        void downloadingChanged();
        void downloadCompleted();
        void downloadError(QString errormessage);

    public slots:
        void downloadFilters(AdBlockManager* adblockmanager);
        void downloadHosts(AdBlockManager* adblockmanager);

    private slots:
        void onNetworkReplyReadyRead();
        void onDownloadProgress(qint64, qint64);
        void onDownloadError(QNetworkReply::NetworkError);
        void onDownloadFinished(QNetworkReply* reply);

    private:
        bool _downloading;
        int _filesdownloaded;
        qint64 _progressvalue;
        qint64 _progresstotal;
        QString _errormessage;
        QString _localfile;
        AdBlockManager* _adblockmanager;
        QNetworkReply* _downloadreply;
        QNetworkAccessManager _networkmanager;
        QFile _tempfile;
        DownloadType _downloadtype;

    private:
        static const int FILES_MAX;
        static const QString GITHUB_RAW_URL;
        static const QString HOSTS_URL;
};

#endif // ADBLOCKDOWNLOADER_H
