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
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)

    public:
        CookieJar(QObject* parent = 0);
        const QStringList& domains() const;
        bool busy() const;

    public slots:
        void load();
        void unload();
        void filter(const QString& s);
        int cookieCount(const QString& domain) const;
        QList<QObject*> getCookies(const QString& domain) const;
        void setCookie(CookieItem* ci);
        void setCookie(const QString& name, const QString& domain, const QString& path, const QDateTime &expires, const QString& value);
        void deleteCookiesFrom(const QString& domain);
        void deleteCookie(CookieItem* ci);
        void deleteAllCookies();

    protected:
        virtual bool open() const;

    private:
        void disposeItems();
        void updateFilter();
        void swapCookie(CookieItem* ci);
        void removeDomain(const QString& domain);
        bool insert(CookieItem* ci, bool update);
        bool exists(CookieItem* ci);
        void populateHashMap(const QList<QNetworkCookie>& cookies);

    private: // SQL Interface
        void commit(CookieItem* ci);
        void commitDelete();
        void commitDelete(const QString& domain);
        void commitDelete(const CookieItem *ci);

    signals:
        void domainsChanged();
        void busyChanged();

    private:
        QHash<QString, QObjectList> _cookiemap;
        QString _filter;
        QStringList _domains;
        QStringList _filtereddomains;
        bool _filtered;
        bool _busy;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString COOKIE_DATABASE;
};

#endif // COOKIEJAR_H
