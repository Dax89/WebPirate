#ifndef MACHINEID_H
#define MACHINEID_H

#include <QtQml>
#include <QFile>
#include <QObject>

class MachineID : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString value READ value CONSTANT FINAL)

    public:
        explicit MachineID(QObject *parent = 0);
        QString value();

    public:
        static QObject* initialize(QQmlEngine *, QJSEngine *);

    private:
        QString _machineid;
};

#endif // MACHINEID_H
