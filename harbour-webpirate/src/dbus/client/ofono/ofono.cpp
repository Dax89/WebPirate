#include "ofono.h"

const QString Ofono::DBUS_SERVICE = "org.ofono";
const QString Ofono::DBUS_INTERFACE = "org.ofono.Manager";

Ofono::Ofono(QObject *parent): QObject(parent), _available(-1)
{
    qDBusRegisterMetaType<OfonoProperty>();
    qDBusRegisterMetaType<OfonoPropertyMap>();

    this->fetchImei();
}

bool Ofono::available()
{
    if(this->_available == -1)
    {
        QDBusConnection bus = QDBusConnection::systemBus();
        QDBusReply<bool> reply = bus.interface()->isServiceRegistered(Ofono::DBUS_SERVICE);
        this->_available = (reply.isValid() ? reply.value() : 0);
    }

    return this->_available;
}

int Ofono::imeiCount() const
{
    return this->_imeilist.count();
}

QObject *Ofono::initialize(QQmlEngine *, QJSEngine *)
{
    return new Ofono();
}

void Ofono::fetchImei()
{
    QDBusConnection bus = QDBusConnection::systemBus();
    QDBusReply<OfonoPropertyMap> reply = bus.call(QDBusMessage::createMethodCall(Ofono::DBUS_SERVICE, "/", Ofono::DBUS_INTERFACE, "GetModems"));

    if(!reply.isValid())
        return;

    foreach(const OfonoProperty& prop, reply.value())
        this->_imeilist.append(prop.Properties["Serial"].toString());
}

QString Ofono::imei(int idx) const
{
    if(idx < 0)
        idx = 0;
    else if(idx >= this->_imeilist.length())
        idx = this->_imeilist.length() - 1;

    return this->_imeilist[idx];
}
