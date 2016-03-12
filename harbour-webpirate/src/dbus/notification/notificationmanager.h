#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>

class NotificationManager : public QObject
{
    Q_OBJECT

    public:
        explicit NotificationManager(QObject *parent = 0);

    public slots:
        void send(const QString& summary, const QString& body, bool feedback, bool temporary);
        void send(const QString& summary, const QString& body);

    private:
        QString _appicon;

    private:
        static const QString APP_PRETTY_NAME;
};

#endif // NOTIFICATIONMANAGER_H
