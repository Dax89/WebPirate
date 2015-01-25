#ifndef WEBPIRATESERVICE_H
#define WEBPIRATESERVICE_H

#include <QObject>
#include <QDebug>
#include <QQuickView>
#include <QDBusConnection>
#include <QDBusError>
#include "webpirateadaptor.h"

class WebPirateService : public QObject
{
    Q_OBJECT

    public:
        explicit WebPirateService(QObject *parent = 0);

    public slots:
        void openUrl(const QString& url);

    signals:
        void urlRequested(QString url);

    public:
        static const QString SERVICE_NAME;
};

#endif // WEBPIRATESERVICE_H
