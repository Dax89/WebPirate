#include "cookiejar.h"

const QString CookieJar::CONNECTION_NAME = "__wp__CookieJar";
const QString CookieJar::WEBKIT_DATABASE = ".QtWebKit";
const QString CookieJar::COOKIE_DATABASE = "cookies.db";

CookieJar::CookieJar(QObject *parent): AbstractDatabase(CookieJar::CONNECTION_NAME, parent), _filtered(false)
{
}

void CookieJar::load()
{
    if(!this->open())
        return;

    if(!this->_cookiemap.isEmpty())
        this->unload(); /* HashMap is not empty: unload and reload */

    QSqlQuery query(QSqlDatabase::database(this->connectionName(), false));
    this->prepare(query, "SELECT cookie FROM cookies");
    this->execute(query);

    while(query.next())
    {
        QList<QNetworkCookie> cookies = QNetworkCookie::parseCookies(query.value(0).toByteArray());
        this->populateHashMap(cookies);
    }

    emit domainsChanged();
}

void CookieJar::unload()
{
    if(!this->open())
        return;

    foreach(QString domain, this->_domains)
    {
        QObjectList& cookies = this->_cookiemap[domain];

        foreach(QObject* ci, cookies)
            ci->deleteLater();
    }

    this->_domains.clear();
    this->_cookiemap.clear();
}

void CookieJar::filter(const QString &s)
{
    if(!s.isEmpty())
    {
        this->_filtereddomains = this->_domains.filter(s, Qt::CaseInsensitive);
        this->_filtered = true;
    }
    else
    {
        this->_filtereddomains.clear();
        this->_filtered = false;
    }

    emit domainsChanged();
}

int CookieJar::cookieCount(const QString &domain) const
{
    return this->_cookiemap[domain].count();
}

QStringList CookieJar::domains() const
{
    if(this->_filtered)
        return this->_filtereddomains;

    return this->_domains;
}

QList<QObject *> CookieJar::getCookies(const QString &domain)
{
    return this->_cookiemap[domain];
}

bool CookieJar::open() const
{
    QSqlDatabase db = QSqlDatabase::database(this->connectionName(), false);

    if(db.isOpen())
        return true;

    QDir dbpath = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!dbpath.cd(CookieJar::WEBKIT_DATABASE) && !dbpath.exists(CookieJar::COOKIE_DATABASE))
        return false;

    db.setDatabaseName(dbpath.absoluteFilePath(CookieJar::COOKIE_DATABASE));
    return db.open();
}

void CookieJar::populateHashMap(const QList<QNetworkCookie> &cookies)
{
    foreach(QNetworkCookie cookie, cookies)
    {
        if(!this->_cookiemap.contains(cookie.domain()))
        {
            this->_domains.append(cookie.domain());
            this->_cookiemap[cookie.domain()] = QObjectList();
        }

        this->_cookiemap[cookie.domain()].append(new CookieItem(cookie));
    }
}
