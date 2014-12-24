#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QHash>
#include <QStandardPaths>
#include "downloaditem.h"

class DownloadManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint64 count READ count NOTIFY countChanged)

    public:
        explicit DownloadManager(QObject *parent = 0);
        qint64 count() const;

    signals:
        void countChanged();

    public slots:
        DownloadItem* downloadItem(int index);
        void createDownload(const QUrl& url);
        void removeCompleted();

    private:
        QHash<QUrl, DownloadItem*> _downloads;
        QList<QUrl> _downloadurls;
};

#endif // DOWNLOADMANAGER_H
