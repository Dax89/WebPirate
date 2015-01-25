#ifndef WEBPIRATEADAPTOR_H
#define WEBPIRATEADAPTOR_H

#include <QDBusAbstractAdaptor>

class WebPirateAdaptor: public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.browser.WebPirate")

    public:
        WebPirateAdaptor(QObject *parent);
        virtual ~WebPirateAdaptor();

    public slots:
        void openUrl(const QString &url);
};

#endif
