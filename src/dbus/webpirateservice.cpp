#include "webpirateservice.h"

const QString WebPirateService::SERVICE_NAME = "org.browser.WebPirate";

WebPirateService::WebPirateService(QObject *parent): QObject(parent)
{
    new WebPirateAdaptor(this);

    QDBusConnection connection = QDBusConnection::sessionBus();

    if(!connection.isConnected())
    {
        qWarning("Cannot connect to the D-Bus session bus.");
        return;
    }

    if(!connection.registerService(WebPirateService::SERVICE_NAME))
    {
        qWarning() << connection.lastError().message();
        return;
    }

    if(!connection.registerObject("/", this))
        qWarning() << connection.lastError().message();
}

void WebPirateService::openUrl(const QString &url)
{
    emit urlRequested(url);
}
