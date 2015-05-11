#include "ofonoproperty.h"

QDBusArgument &operator <<(QDBusArgument &argument, const OfonoProperty &prop)
{
    argument.beginStructure();
    argument << prop.Path << prop.Properties;
    argument.endStructure();

    return argument;
}

const QDBusArgument &operator >>(const QDBusArgument &argument, OfonoProperty &prop)
{
    argument.beginStructure();
    argument >> prop.Path >> prop.Properties;
    argument.endStructure();

    return argument;
}
