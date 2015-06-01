#include "notifications.h"

Notifications::Notifications(QObject *parent): QObject(parent)
{
}

void Notifications::send(const QString &summary, const QString &body)
{
    QList<QVariant> args;
    QDBusMessage message = QDBusMessage::createMethodCall("org.freedesktop.Notifications", "/org/freedesktop/Notifications", "org.freedesktop.Notifications", "Notify");

    args << qApp->applicationName();
    args << 0u;
    args << QString();
    args << summary;
    args << body;
    args << QVariant::fromValue(QStringList());
    args << QVariant::fromValue(QVariantMap());
    args << -1;

    QDBusConnection connection(QDBusConnection::sessionBus());
    message.setArguments(args);
    connection.send(message);
}
