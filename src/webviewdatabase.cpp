#include "webviewdatabase.h"

WebViewDatabase::WebViewDatabase(QObject *parent): QObject(parent)
{

}

void WebViewDatabase::clearNavigationData()
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.cd(".QtWebKit"))
        return;

    datadir.removeRecursively();
}
