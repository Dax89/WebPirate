#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QHash>
#include <QStandardPaths>
#include "downloaditem.h"
#include "webviewdownloaditem.h"
#include "webpagedownloaditem.h"

class DownloadManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint64 count READ count NOTIFY countChanged)

    public:
        explicit DownloadManager(QObject *parent = 0);
        qint64 count() const;

    signals:
        void countChanged();
        void downloadCompleted(const QString& filename);
        void downloadFailed(const QString& filename);

    public slots:
        AbstractDownloadItem *downloadItem(int index);
        void createDownloadFromUrl(const QUrl& url);
        void createDownloadFromUrl(const QUrl& url, const QString& filename);
        void createDownloadFromPage(const QString& html);
        void createDownload(QWebDownloadItem* downloaditem);
        void removeCompleted();

    private:
        QList<AbstractDownloadItem*> _downloads;
};

#endif // DOWNLOADMANAGER_H
