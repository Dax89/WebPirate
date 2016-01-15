#include "cookiejar.h"

const QString CookieJar::CONNECTION_NAME = "__wp__CookieJar";
const QString CookieJar::WEBKIT_DATABASE = ".QtWebKit";
const QString CookieJar::COOKIE_DATABASE = "cookies.db";

CookieJar::CookieJar(QObject *parent): AbstractDatabase(CookieJar::CONNECTION_NAME, parent), _filtered(false), _busy(true)
{
}

void CookieJar::load()
{
    if(!this->open())
        return;

    this->_busy = true;
    emit busyChanged();

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

    this->_busy = false;
    emit busyChanged();
    emit domainsChanged();
}

void CookieJar::unload()
{    
    this->_busy = true; // Restore 'busy' state
    this->disposeItems();
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

    this->_filter = s;
    emit domainsChanged();
}

int CookieJar::cookieCount(const QString &domain) const
{
    return this->_cookiemap[domain].count();
}

const QStringList &CookieJar::domains() const
{
    if(this->_filtered)
        return this->_filtereddomains;

    return this->_domains;
}

bool CookieJar::busy() const
{
    return this->_busy;
}

QList<QObject *> CookieJar::getCookies(const QString &domain) const
{
    return this->_cookiemap[domain];
}

void CookieJar::setCookie(CookieItem *ci)
{
    this->swapCookie(ci);
    this->updateFilter();
    this->commit(ci);
}

void CookieJar::setCookie(const QString &name, const QString &domain, const QString &path, const QDateTime &expires, const QString &value)
{
    CookieItem* ci = new CookieItem(domain, name, value); // Create a New Cookie
    ci->setPath(path);
    ci->setExpires(expires);
    ci->setValue(value);

    if(this->insert(ci, true))
    {
        this->updateFilter();
        this->commit(ci);
    }
}

void CookieJar::deleteCookiesFrom(const QString &domain)
{
    if(!this->_cookiemap.contains(domain))
        return;

    QObjectList& cookies = this->_cookiemap[domain];

    while(!cookies.empty())
    {
        cookies[0]->deleteLater();
        cookies.removeAt(0);
    }

    this->_cookiemap.remove(domain);
    this->removeDomain(domain);
}

void CookieJar::deleteCookie(CookieItem *ci)
{
    if(!this->_cookiemap.contains(ci->domain()))
        return;

    QObjectList& cookies = this->_cookiemap[ci->domain()];
    int idx = cookies.indexOf(ci);

    if(idx == -1)
        return;

    cookies.removeAt(idx);

    if(cookies.isEmpty())
    {
        this->_cookiemap.remove(ci->domain());
        this->removeDomain(ci->domain()); // Triggers SQL query too
    }
    else
    {
        this->commitDelete(ci); // Delete this cookie only
        emit domainsChanged(); // Cookie count is changed, update list
    }

    ci->deleteLater(); // Free Object
}

void CookieJar::deleteAllCookies()
{
    this->disposeItems();
    emit domainsChanged();

    this->commitDelete();
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

void CookieJar::disposeItems()
{
    foreach(QString domain, this->_domains)
    {
        QObjectList& cookies = this->_cookiemap[domain];

        foreach(QObject* ci, cookies)
            ci->deleteLater();
    }

    this->_filtered = false;
    this->_filter.clear();
    this->_filtereddomains.clear();

    this->_domains.clear();
    this->_cookiemap.clear();
}

void CookieJar::updateFilter()
{
    this->filter(this->_filter);
}

void CookieJar::swapCookie(CookieItem *ci)
{
    if(ci->originalDomain() == ci->domain())
        return;

    QObjectList& cookies = this->_cookiemap[ci->originalDomain()];
    int idx = cookies.indexOf(ci);

    if(idx == -1)
        return;

    cookies.removeAt(idx);

    if(cookies.isEmpty())
    {
        this->_cookiemap.remove(ci->originalDomain());
        this->removeDomain(ci->originalDomain());
    }

    this->insert(ci, true);
}

void CookieJar::removeDomain(const QString &domain)
{
    int idx = this->_domains.indexOf(domain);

    if(idx == -1)
        return;

    this->_domains.removeAt(idx);
    this->commitDelete(domain);
    this->updateFilter();
    emit domainsChanged();
}

bool CookieJar::insert(CookieItem *ci, bool update)
{
    if(!this->_cookiemap.contains(ci->domain()))
    {
        this->_domains.append(ci->domain());
        this->_cookiemap[ci->domain()] = QObjectList();

        if(update)
            emit domainsChanged();
    }
    else if(this->exists(ci)) // Avoid Duplicates
    {
        ci->deleteLater(); // Dispose
        return false;
    }

    this->_cookiemap[ci->domain()].append(ci);
    return true;
}

bool CookieJar::exists(CookieItem *ci)
{
    if(!this->_cookiemap.contains(ci->domain()))
        return false;

    const QObjectList& cookies = this->_cookiemap[ci->domain()];
    int idx = cookies.indexOf(ci);

    return idx != -1;
}

void CookieJar::populateHashMap(const QList<QNetworkCookie> &cookies)
{
    foreach(QNetworkCookie cookie, cookies)
        this->insert(new CookieItem(cookie), false);
}

void CookieJar::commit(CookieItem *ci)
{
    if(!this->open())
        return;

    QSqlQuery query(QSqlDatabase::database(this->connectionName(), false));

    if(!this->prepare(query, "DELETE FROM cookies WHERE cookieId = ?"))
        return;

    QString cookieid = QString("%1%2").arg(ci->originalDomain(), ci->originalName());
    query.bindValue(0, cookieid);

    if(!this->execute(query))
        return;

    if(!this->prepare(query, "INSERT OR REPLACE INTO cookies (cookieId, cookie) VALUES(?, ?)"))
        return;

    cookieid = QString("%1%2").arg(ci->domain(), ci->name());
    query.bindValue(0, cookieid);
    query.bindValue(1, ci->toRawForm());
    this->execute(query);
}

void CookieJar::commitDelete()
{
    if(!this->open())
        return;

    QSqlQuery query(QSqlDatabase::database(this->connectionName(), false));

    if(!this->prepare(query, "DELETE FROM cookies"))
        return;

    this->execute(query);
}

void CookieJar::commitDelete(const QString &domain)
{
    if(!this->open())
        return;

    QSqlQuery query(QSqlDatabase::database(this->connectionName(), false));

    if(!this->prepare(query, "DELETE FROM cookies WHERE cookieId LIKE ?"))
        return;

    query.bindValue(0, domain + "%");
    this->execute(query);
}

void CookieJar::commitDelete(const CookieItem* ci)
{
    if(!this->open())
        return;

    QSqlQuery query(QSqlDatabase::database(this->connectionName(), false));

    if(!this->prepare(query, "DELETE FROM cookies WHERE cookieId = ?"))
        return;

    QString cookieid = QString("%1%2").arg(ci->domain(), ci->name());
    query.bindValue(0, cookieid);
    this->execute(query);
}
