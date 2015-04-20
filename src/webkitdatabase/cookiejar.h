#ifndef COOKIEJAR_H
#define COOKIEJAR_H

#include <QHash>
#include <QNetworkCookie>
#include "abstractdatabase.h"

class CookieJar: public AbstractDatabase
{
    public:
        CookieJar(QObject* parent = 0);

    public slots:
        void load();
        void unload();

    protected:
        virtual bool open() const;

    private:
        void populateHashMap(const QList<QNetworkCookie>& cookies);

    private:
        QHash<QString, QList<QNetworkCookie> > _cookiemap;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString COOKIE_DATABASE;
};

#endif // COOKIEJAR_H
