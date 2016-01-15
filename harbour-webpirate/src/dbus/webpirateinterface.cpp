#include "webpirateinterface.h"

const QString WebPirateInterface::INTERFACE_NAME = "org.harbour.webpirate";

WebPirateInterface::WebPirateInterface(QObject *parent): QObject(parent)
{
    qDBusRegisterMetaType<QStringList>();
    new WebPirateAdaptor(this);

    QDBusConnection connection = QDBusConnection::sessionBus();

    if(!connection.isConnected())
    {
        qWarning("Cannot connect to the D-Bus session bus.");
        return;
    }

    if(!connection.registerService(WebPirateInterface::INTERFACE_NAME))
    {
        qWarning() << connection.lastError().message();
        return;
    }

    if(!connection.registerObject("/", this))
        qWarning() << connection.lastError().message();
}

void WebPirateInterface::sendArgs(const QStringList &args)
{
    QList<QVariant> urls;
    urls.append(QVariant::fromValue(args));

    QDBusMessage message = QDBusMessage::createMethodCall(WebPirateInterface::INTERFACE_NAME, "/", WebPirateInterface::INTERFACE_NAME, "openUrl");
    QDBusConnection connection(QDBusConnection::sessionBus());

    message.setArguments(urls);
    connection.asyncCall(message);
}

void WebPirateInterface::openSingleUrl(const QString &url)
{
    this->sendArgs((QStringList() << url));
}

void WebPirateInterface::openUrl(const QStringList &args)
{
    emit urlRequested(args);
}
