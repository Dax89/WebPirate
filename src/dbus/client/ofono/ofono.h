#ifndef OFONO_H
#define OFONO_H

#include <QtDBus>
#include <QtQml>
#include <QObject>
#include "ofonoproperty.h"

class Ofono : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool available READ available CONSTANT FINAL)
    Q_PROPERTY(int imeiCount READ imeiCount CONSTANT FINAL)

    public:
        explicit Ofono(QObject *parent = 0);
        bool available();
        int imeiCount() const;

    public:
        static QObject *initialize(QQmlEngine*, QJSEngine*);

    private:
        void fetchImei();

    public slots:
        QString imei(int idx) const;

    private:
        int _available;
        QList<QString> _imeilist;

    private:
        static const QString DBUS_SERVICE;
        static const QString DBUS_INTERFACE;
};

#endif // OFONO_H
