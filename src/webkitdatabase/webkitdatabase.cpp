#include "webkitdatabase.h"

const QString WebKitDatabase::OLD_DB_NAME = "WebPirate";
const QString WebKitDatabase::WEBKIT_DATABASE = ".QtWebKit";

WebKitDatabase::WebKitDatabase(QObject *parent): QObject(parent)
{
    this->renameDatabase();
}

void WebKitDatabase::renameDatabase()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

    /* Application renamed: Migrate the Database, if needed */
    if(datadir.exists(WebKitDatabase::OLD_DB_NAME))
    {
        datadir.cd(WebKitDatabase::OLD_DB_NAME);
        datadir.rename(WebKitDatabase::OLD_DB_NAME, qAppName());
        datadir.cdUp();
        datadir.rename(WebKitDatabase::OLD_DB_NAME, qAppName());
    }
}

void WebKitDatabase::clearNavigationData()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(datadir.cd(WebKitDatabase::WEBKIT_DATABASE))
        datadir.removeRecursively();
}

void WebKitDatabase::clearCache()
{
    QDir cachedir = QDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation));

    if(cachedir.cd(WebKitDatabase::WEBKIT_DATABASE))
        cachedir.removeRecursively();
}
