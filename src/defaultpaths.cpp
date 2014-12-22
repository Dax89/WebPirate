#include "defaultpaths.h"

DefaultPaths::DefaultPaths(QObject *parent): QObject(parent)
{
}

QString DefaultPaths::homeDirectory() const
{
    return QDir::homePath();
}

QString DefaultPaths::downloadDirectory() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}
