#ifndef COOKIEJAR_H
#define COOKIEJAR_H

#include <QHash>
#include <QStringList>
#include <QNetworkCookie>
#include "../abstractdatabase.h"
#include "cookieitem.h"

class CookieJar: public AbstractDatabase
{
    Q_OBJECT

    Q_PROPERTY(QStringList domains READ domains NOTIFY domainsChanged)

    public:
        CookieJar(QObject* parent = 0);
        QStringList domains() const;

    public slots:
        void load();
        void unload();
        void filter(const QString& s);
        int cookieCount(const QString& domain) const;
        QList<QObject*> getCookies(const QString& domain);

    protected:
        virtual bool open() const;

    private:
        void populateHashMap(const QList<QNetworkCookie>& cookies);

    signals:
        void domainsChanged();

    private:
        QHash<QString, QObjectList> _cookiemap;
        QStringList _domains;
        QStringList _filtereddomains;
        bool _filtered;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString COOKIE_DATABASE;
};

#endif // COOKIEJAR_H
