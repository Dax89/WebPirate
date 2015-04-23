#include "downloadmanager.h"

DownloadManager::DownloadManager(QObject *parent): QObject(parent)
{

}

AbstractDownloadItem *DownloadManager::downloadItem(int index)
{
    return this->_downloads[index];
}

qint64 DownloadManager::count() const
{
    return this->_downloads.count();
}

void DownloadManager::createDownloadFromUrl(const QUrl &url)
{
    this->createDownloadFromUrl(url, QString());
}

void DownloadManager::createDownloadFromUrl(const QUrl &url, const QString &filename)
{
    DownloadItem* di = new DownloadItem(url, filename, this);
    this->_downloads.append(di);

    di->start();
    emit countChanged();
}

void DownloadManager::createDownload(QWebDownloadItem* downloaditem)
{
    WebViewDownloadItem* di = new WebViewDownloadItem(downloaditem, this);
    this->_downloads.append(di);

    di->start();
    emit countChanged();
}

void DownloadManager::removeCompleted()
{
    int i = 0;

    while(i < this->_downloads.count())
    {
        AbstractDownloadItem* di = this->_downloads[i];

        if(!di->completed())
        {
            i++;
            continue;
        }

        this->_downloads.removeAt(i);
    }

    emit countChanged();
}
