#include "downloadmanager.h"

DownloadManager::DownloadManager(QObject *parent): QObject(parent)
{

}

DownloadItem *DownloadManager::downloadItem(int index)
{
    return this->_downloads[this->_downloadurls[index]];
}

qint64 DownloadManager::count() const
{
    return this->_downloads.count();
}

void DownloadManager::createDownload(const QUrl &url)
{
    DownloadItem* di = new DownloadItem(url, this);

    this->_downloadurls.append(url);
    this->_downloads[url] = di;

    di->start();
    emit countChanged();
}

void DownloadManager::removeCompleted()
{
    int i = 0;

    while(i < this->_downloadurls.count())
    {
        const QUrl& url = this->_downloadurls[i];

        if(!this->_downloads[url]->completed())
        {
            i++;
            continue;
        }

        this->_downloads.remove(url);
        this->_downloadurls.removeAt(i);
    }

    emit countChanged();
}
