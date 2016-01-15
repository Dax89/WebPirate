#include "machineid.h"

MachineID::MachineID(QObject *parent): QObject(parent)
{
}

QString MachineID::value()
{
    if(this->_machineid.isEmpty())
    {
        QFile file("/var/lib/dbus/machine-id");
        file.open(QFile::ReadOnly);
        this->_machineid = QString(file.readAll()).simplified();
        file.close();
    }

    return this->_machineid;
}

QObject *MachineID::initialize(QQmlEngine *, QJSEngine *)
{
    return new MachineID();
}
