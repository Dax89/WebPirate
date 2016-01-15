#ifndef WEBPAGEDOWNLOADITEM_H
#define WEBPAGEDOWNLOADITEM_H

#include "abstractdownloaditem.h"

class WebPageDownloadItem: public AbstractDownloadItem
{
    Q_OBJECT

    public:
        explicit WebPageDownloadItem(const QString& html, QObject *parent = 0);

    public slots:
        virtual void start();
        virtual void cancel();

    private:
        static const QString DEFAULT_FILENAME;

    private:
        QFile _file;
        QString _html;
};

#endif // WEBPAGEDOWNLOADITEM_H
