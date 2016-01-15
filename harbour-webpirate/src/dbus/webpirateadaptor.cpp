#include "webpirateadaptor.h"

WebPirateAdaptor::WebPirateAdaptor(QObject *parent): QDBusAbstractAdaptor(parent)
{

}

WebPirateAdaptor::~WebPirateAdaptor()
{

}

void WebPirateAdaptor::openUrl(const QStringList &args)
{
    QMetaObject::invokeMethod(parent(), "openUrl", Q_ARG(QStringList, args));
}

