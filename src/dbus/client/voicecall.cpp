#include "voicecall.h"

VoiceCall::VoiceCall(QObject *parent): QObject(parent)
{

}

void VoiceCall::compose(const QString &tel)
{
    QList<QVariant> args;
    args.append(QVariant::fromValue((QStringList() << tel)));

    QDBusMessage message = QDBusMessage::createMethodCall("com.jolla.voicecall.ui", "/", "com.jolla.voicecall.ui", "openUrl");
    QDBusConnection connection(QDBusConnection::sessionBus());

    message.setArguments(args);
    connection.send(message);
}
