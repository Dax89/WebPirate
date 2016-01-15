#ifndef WEBVIEWDOWNLOADITEM_H
#define WEBVIEWDOWNLOADITEM_H

#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include "abstractdownloaditem.h"

/* MOC needs this, otherwise 'webkit-private' is needed in order to connect failed() signal */
class QWebDownloadItem: public QObject
{
    Q_OBJECT

    Q_ENUMS(DownloadError)

    private:
        explicit QWebDownloadItem(QObject* = 0) { }

    public:
        enum DownloadError {
            Aborted = 0,
            CannotWriteToFile,
            CannotOpenFile,
            DestinationAlreadyExists,
            Cancelled,
            CannotDetermineFilename,
            NetworkFailure
        };
};

class WebViewDownloadItem : public AbstractDownloadItem
{
    Q_OBJECT

    public:
        explicit WebViewDownloadItem(QObject *downloaditem, QObject *parent = 0);

    private:
        QVariant getProperty(const QObject* obj, const char* name) const ;
        bool setProperty(QObject* obj, const char* name, QVariant value) const ;
        void removeFile();

    public:
        virtual void start();
        virtual void cancel();

    private slots:
        void onByteReceivedChanged(quint64 bytesreceived);
        void onDownloadSucceeded();
        void onDownloadFailed(QWebDownloadItem::DownloadError, const QUrl&, const QString& description);

    private:
        QObject* _downloaditem;
};

#endif // WEBVIEWDOWNLOADITEM_H
