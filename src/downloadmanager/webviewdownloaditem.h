#ifndef WEBVIEWDOWNLOADITEM_H
#define WEBVIEWDOWNLOADITEM_H

#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include <QtWebKit/private/qwebdownloaditem_p.h>
#include "abstractdownloaditem.h"

class WebViewDownloadItem : public AbstractDownloadItem
{
    Q_OBJECT

    public:
        explicit WebViewDownloadItem(QWebDownloadItem* downloaditem, QObject *parent = 0);

    private:
        void removeFile();

    public:
        virtual void start();
        virtual void cancel();

    private slots:
        void onByteReceivedChanged(quint64 bytesreceived);
        void onDownloadSucceeded();
        void onDownloadFailed(QWebDownloadItem::DownloadError, const QUrl&, const QString& description);

    private:
        QWebDownloadItem* _downloaditem;
};

#endif // WEBVIEWDOWNLOADITEM_H
