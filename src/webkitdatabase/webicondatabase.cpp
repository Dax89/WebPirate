#include "webicondatabase.h"

const QString WebIconDatabase::CONNECTION_NAME = "__wp__WebpageIcons";
const QString WebIconDatabase::WEBKIT_DATABASE = ".QtWebKit";
const QString WebIconDatabase::ICON_DATABASE = "WebpageIcons.db";
const QString WebIconDatabase::PROVIDER_NAME = "favicons";

WebIconDatabase::WebIconDatabase(QObject *parent): AbstractDatabase(WebIconDatabase::CONNECTION_NAME, parent)
{

}

bool WebIconDatabase::hasIcon(const QString &url)
{
    QString s = this->queryIconUrl(url);

    if(s.isEmpty())
        return false;

    QByteArray b = this->queryIconPixmap(url);
    return !b.isEmpty();
}

QString WebIconDatabase::provideIcon(const QString &url)
{
    if(this->hasIcon(url))
        return QString("image://%1/%2").arg(WebIconDatabase::PROVIDER_NAME, url);

    return "image://theme/icon-m-favorite-selected";
}

bool WebIconDatabase::open() const
{
    QSqlDatabase db = QSqlDatabase::database(WebIconDatabase::CONNECTION_NAME, false);

    if(db.isOpen())
        return true;

    QDir dbpath = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!dbpath.cd(WebIconDatabase::WEBKIT_DATABASE))
        return false;

    db.setDatabaseName(dbpath.absoluteFilePath(WebIconDatabase::ICON_DATABASE));
    return db.open();
}

int WebIconDatabase::queryIconId(const QString &url)
{
    if(!this->open())
        return -1;

    QUrl urlobj = QUrl::fromUserInput(this->adjustUrl(url));
    QString host = urlobj.host();

    if(host.isEmpty())
        return -1;

    QSqlDatabase db = QSqlDatabase::database(WebIconDatabase::CONNECTION_NAME, false);
    QSqlQuery q(db);

    if(!this->prepare(q, "SELECT iconID FROM PageURL WHERE url LIKE ?"))
        return -1;

    q.bindValue(0, "%" + host + "%");

    if(!this->execute(q) || !q.first())
        return -1;

    return q.value(0).toInt();
}

QString WebIconDatabase::adjustUrl(const QString &url) const
{
    if(url[0] == '.')
        return url.mid(1); // Adjust URLs from cookies.db

    return url;
}

QString WebIconDatabase::queryIconUrl(const QString &url)
{
    int iconid = this->queryIconId(url);

    if(iconid == -1)
        return QString();

    QSqlDatabase db = QSqlDatabase::database(WebIconDatabase::CONNECTION_NAME, false);
    QSqlQuery q(db);

    if(!this->prepare(q, "SELECT url FROM IconInfo WHERE iconID = ?"))
        return QString();

    q.bindValue(0, iconid);

    if(!this->execute(q) || !q.first())
        return QString();

    return q.value(0).toString();
}

QByteArray WebIconDatabase::queryIconPixmap(const QString &url)
{
    int iconid = this->queryIconId(url);

    if(iconid == -1)
        return QByteArray();

    QSqlDatabase db = QSqlDatabase::database(WebIconDatabase::CONNECTION_NAME, false);
    QSqlQuery q(db);

    if(!this->prepare(q, "SELECT data FROM IconData WHERE iconID = ?"))
        return QByteArray();

    q.bindValue(0, iconid);

    if(!this->execute(q) || !q.first())
        return QByteArray();

    return q.value(0).toByteArray();
}
