#include "webpirateadaptor.h"

WebPirateAdaptor::WebPirateAdaptor(QObject *parent): QDBusAbstractAdaptor(parent)
{

}

WebPirateAdaptor::~WebPirateAdaptor()
{

}

void WebPirateAdaptor::openUrl(const QString &url)
{
    QMetaObject::invokeMethod(parent(), "openUrl", Q_ARG(QString, url));
}

