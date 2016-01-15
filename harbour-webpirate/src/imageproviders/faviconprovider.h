#ifndef FAVICONPROVIDER_H
#define FAVICONPROVIDER_H

#include <QQuickImageProvider>
#include "../webkitdatabase/webicondatabase.h"

class FaviconProvider : public QQuickImageProvider
{
    public:
        FaviconProvider();
        virtual QImage requestImage(const QString& id, QSize* size, const QSize&);

    private:
        WebIconDatabase _icondb;
};

#endif // FAVICONPROVIDER_H
