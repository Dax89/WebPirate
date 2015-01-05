#include "downloadmanager.h"

DownloadManager::DownloadManager(QObject *parent): QObject(parent)
{

}

DownloadItem *DownloadManager::downloadItem(int index)
{
    return this->_downloads[index];
}

qint64 DownloadManager::count() const
{
    return this->_downloads.count();
}

void DownloadManager::createDownload(const QUrl &url)
{
    DownloadItem* di = new DownloadItem(url, this);
    this->_downloads.append(di);

    di->start();
    emit countChanged();
}

void DownloadManager::removeCompleted()
{
    int i = 0;

    while(i < this->_downloads.count())
    {
        DownloadItem* di = this->_downloads[i];

        if(!di->completed())
        {
            i++;
            continue;
        }

        this->_downloads.removeAt(i);
    }

    emit countChanged();
}
