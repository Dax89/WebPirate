#ifndef NETWORKINTERFACES_H
#define NETWORKINTERFACES_H

#include <QtNetwork>
#include <QtQml>
#include <QObject>

class NetworkInterfaces : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int interfaceCount READ interfaceCount CONSTANT FINAL)

    public:
        explicit NetworkInterfaces(QObject *parent = 0);
        int interfaceCount() const;

    public:
        static QObject *initialize(QQmlEngine*, QJSEngine*);

    public slots:
        QString interfaceMAC(int idx) const;

    private:
        QList<QString> _maclist;
};

#endif // NETWORKINTERFACES_H
