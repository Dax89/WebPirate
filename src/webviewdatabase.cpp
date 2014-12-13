#include "webviewdatabase.h"

const QString WebViewDatabase::OLD_DB_NAME = "WebPirate";

WebViewDatabase::WebViewDatabase(QObject *parent): QObject(parent)
{
    this->renameDatabase();
}

void WebViewDatabase::renameDatabase()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

    /* Application renamed: Migrate the Database, if needed */
    if(datadir.exists(WebViewDatabase::OLD_DB_NAME))
    {
        datadir.cd(WebViewDatabase::OLD_DB_NAME);
        datadir.rename(WebViewDatabase::OLD_DB_NAME, qAppName());
        datadir.cdUp();
        datadir.rename(WebViewDatabase::OLD_DB_NAME, qAppName());
    }
}

void WebViewDatabase::clearNavigationData()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.cd(".QtWebKit"))
        return;

    datadir.removeRecursively();
}
