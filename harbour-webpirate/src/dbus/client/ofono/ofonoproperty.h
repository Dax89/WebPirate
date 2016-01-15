#ifndef OFONOPROPERTY_H
#define OFONOPROPERTY_H

#include <QtDBus>

struct OfonoProperty
{
    QDBusObjectPath Path;
    QVariantMap Properties;
};

QDBusArgument& operator <<(QDBusArgument &argument, const OfonoProperty &prop);
const QDBusArgument& operator >>(const QDBusArgument &argument, OfonoProperty& prop);

typedef QList<OfonoProperty> OfonoPropertyMap;

Q_DECLARE_METATYPE(OfonoProperty)
Q_DECLARE_METATYPE(OfonoPropertyMap)

#endif // OFONOPROPERTY_H
