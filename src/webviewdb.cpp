#include "webviewdb.h"

WebViewDB::WebViewDB(QObject *parent): QObject(parent)
{

}

void WebViewDB::clearNavigationData()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.cd(".QtWebKit"))
        return;

    datadir.removeRecursively();
}
