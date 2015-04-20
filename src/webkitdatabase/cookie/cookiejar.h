#ifndef COOKIEJAR_H
#define COOKIEJAR_H

#include <QHash>
#include <QNetworkCookie>
#include "../abstractdatabase.h"
#include "cookieitem.h"

class CookieJar: public AbstractDatabase
{
    Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)

    public:
        CookieJar(QObject* parent = 0);
        int count() const;

    public slots:
        void load();
        void unload();
        QString getDomain(int idx) const;
        int cookieCount(const QString& domain) const;

    protected:
        virtual bool open() const;

    private:
        void populateHashMap(const QList<QNetworkCookie>& cookies);

    signals:
        void countChanged();

    private:
        QHash<QString, QList<CookieItem*> > _cookiemap;
        QList<QString> _domains;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString COOKIE_DATABASE;
};

#endif // COOKIEJAR_H
