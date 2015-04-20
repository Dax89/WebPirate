#include "cookiejar.h"

const QString CookieJar::CONNECTION_NAME = "__wp__CookieJar";
const QString CookieJar::WEBKIT_DATABASE = ".QtWebKit";
const QString CookieJar::COOKIE_DATABASE = "cookies.db";

CookieJar::CookieJar(QObject *parent): AbstractDatabase(CookieJar::CONNECTION_NAME, parent)
{
}

int CookieJar::count() const
{
    return this->_cookiemap.count();
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

    emit countChanged();
}

void CookieJar::unload()
{
    if(!this->open())
        return;

    foreach(QString domain, this->_domains)
    {
        QList<CookieItem*>& cookies = this->_cookiemap[domain];

        foreach(CookieItem* ci, cookies)
            ci->deleteLater();
    }

    this->_domains.clear();
    this->_cookiemap.clear();
}

QString CookieJar::getDomain(int idx) const
{
    return this->_domains.at(idx);
}

int CookieJar::cookieCount(const QString &domain) const
{
    return this->_cookiemap[domain].count();
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
            this->_cookiemap[cookie.domain()] = QList<CookieItem*>();
        }

        this->_cookiemap[cookie.domain()].append(new CookieItem(cookie));
    }
}
