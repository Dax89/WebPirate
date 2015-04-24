#include "urlcomposer.h"

UrlComposer::UrlComposer(QObject *parent): QObject(parent)
{

}

void UrlComposer::compose(const QString &tel) const
{
    QList<QVariant> args;
    args.append(QVariant::fromValue((QStringList() << tel)));

    QDBusMessage message = QDBusMessage::createMethodCall("com.jolla.voicecall.ui", "/", "com.jolla.voicecall.ui", "openUrl");
    QDBusConnection connection(QDBusConnection::sessionBus());

    message.setArguments(args);
    connection.send(message);
}

void UrlComposer::send(const QString &sms) const
{
    QList<QVariant> args;
    args.append(QVariant::fromValue((QStringList() << sms)));

    QDBusMessage message = QDBusMessage::createMethodCall("org.nemomobile.qmlmessages", "/", "org.nemomobile.qmlmessages", "openUrl");
    QDBusConnection connection(QDBusConnection::sessionBus());

    message.setArguments(args);
    connection.send(message);
}

void UrlComposer::mailTo(const QString &mail) const
{
    QList<QVariant> args;
    args.append(QVariant::fromValue((QStringList() << mail)));

    QDBusMessage message = QDBusMessage::createMethodCall("com.jolla.email.ui", "/com/jolla/email/ui", "com.jolla.email.ui", "mailto");
    QDBusConnection connection(QDBusConnection::sessionBus());

    message.setArguments(args);
    connection.send(message);
}
