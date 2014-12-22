import QtQuick 2.0

ListModel
{
    id: downloadmanager

    function findDownload(downloadid)
    {
        for(var i = 0; i < downloadmanager.count; i++)
        {
            var download = downloadmanager.get(i);

            if(download.id === downloadid)
                return download;
        }

        return null;
    }

    function calculateSpeed(download)
    {
        var speed = download.downloader.totalBytesReceived - download.lastBytesReceived;
        download.lastBytesReceived = download.downloader.totalBytesReceived;

        if(speed < 1024)
            return speed.toFixed(1) + " B/s";
        else if(speed < (1024 * 1024))
            return (speed / 1024).toFixed(1) + " KB/s";

        return (speed / (1024 * 1024)).toFixed(1) + " MB/s";
    }

    function createDownload(downloadItem)
    {
        downloadmanager.append({"id": downloadItem.url.toString(), "downloader": downloadItem, "lastBytesReceived": 0});

        downloadItem.destinationPath = defaultpaths.downloadDirectory + "/" + downloadItem.suggestedFilename
        downloadItem.start();
    }

    function restartDownload(download)
    {
        download.lastBytesReceived = 0;

        download.downloader.cancel();
        download.downloader.start();
    }

    function cancelDownload(download)
    {
        download.downloader.cancel();
    }
}
