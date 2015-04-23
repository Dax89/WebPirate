#ifndef DOWNLOADITEM_H
#define DOWNLOADITEM_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>
#include <QDir>
#include "abstractdownloaditem.h"

class DownloadItem: public AbstractDownloadItem
{
    Q_OBJECT

    public:
        DownloadItem(QObject* parent = 0);
        DownloadItem(const QUrl& url, const QString& filename, QObject* parent = 0);

    private:
        QString parseFileName(const QUrl& url);

    public slots:
        virtual void start();
        virtual void cancel();

    private slots:
        void onNetworkReplyReadyRead();
        void onDownloadError(QNetworkReply::NetworkError);
        void onDownloadFinished(QNetworkReply* reply);
        void onDownloadProgress(qint64 bytesreceived, qint64 bytestotal);

    private:
        static const QString DEFAULT_FILENAME;

    private:
        QUrl _redirectfromurl;
        QFile _file;
        QNetworkAccessManager _networkmanager;
        QNetworkReply* _downloadreply;
};

Q_DECLARE_METATYPE(DownloadItem*)

#endif // DOWNLOADITEM_H
