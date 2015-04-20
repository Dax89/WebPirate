#include "cookiejar.h"

const QString CookieJar::CONNECTION_NAME = "__wp__CookieJar";
const QString CookieJar::WEBKIT_DATABASE = ".QtWebKit";
const QString CookieJar::COOKIE_DATABASE = "cookies.db";

CookieJar::CookieJar(QObject *parent): AbstractDatabase(CookieJar::CONNECTION_NAME, parent)
{
}

void CookieJar::load()
{
    if(!this->open())
        return;

    if(!this->_cookiemap.isEmpty())
        this->_cookiemap.clear();

    QSqlQuery query;
    this->prepare(query, "SELECT cookie FROM cookies");
    this->execute(query);

    while(query.next())
    {
        QList<QNetworkCookie> cookies = QNetworkCookie::parseCookies(query.value(0).toByteArray());
        this->populateHashMap(cookies);
    }
}

void CookieJar::unload()
{
    if(!this->open())
        return;

    this->_cookiemap.clear();
}

bool CookieJar::open() const
{
    QSqlDatabase db = QSqlDatabase::database(this->connectionName(), false);

    if(db.isOpen())
        return true;

    QDir dbpath = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!dbpath.cd(CookieJar::WEBKIT_DATABASE))
        return false;

    db.setDatabaseName(dbpath.absoluteFilePath(CookieJar::COOKIE_DATABASE));
    return db.open();
}

void CookieJar::populateHashMap(const QList<QNetworkCookie> &cookies)
{
    foreach(QNetworkCookie cookie, cookies)
    {
        if(!this->_cookiemap.contains(cookie.domain()))
            this->_cookiemap[cookie.domain()] = QList<QNetworkCookie>();

        this->_cookiemap[cookie.domain()].append(cookie);
    }
}
