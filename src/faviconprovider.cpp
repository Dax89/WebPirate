#include "faviconprovider.h"

FaviconProvider::FaviconProvider(): QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage FaviconProvider::requestImage(const QString &id, QSize *size, const QSize &)
{
    QByteArray ba = this->_icondb.queryIconPixmap(id);

    if(ba.isEmpty())
        return QImage();

    QImage img = QImage::fromData(ba);

    if(img.isNull())
        return QImage();

    *size = img.size();
    return img;
}
