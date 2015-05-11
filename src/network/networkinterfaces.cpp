#include "networkinterfaces.h"

NetworkInterfaces::NetworkInterfaces(QObject *parent): QObject(parent)
{
     QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();

     foreach(const QNetworkInterface& interface, interfaces)
     {
         if(interface.flags() & QNetworkInterface::CanBroadcast) /* Ignore Other interfaces */
             this->_maclist.append(interface.hardwareAddress());
     }
}

int NetworkInterfaces::interfaceCount() const
{
    return this->_maclist.length();
}

QObject *NetworkInterfaces::initialize(QQmlEngine *, QJSEngine *)
{
    return new NetworkInterfaces();
}

QString NetworkInterfaces::interfaceMAC(int idx) const
{
    if(idx < 0)
        idx = 0;
    else if(idx >= this->_maclist.length())
        idx = this->_maclist.length() - 1;

    return this->_maclist[idx];
}
