#include "defaultbrowser.h"

const QString DefaultBrowser::LOCAL_SERVICE = "org.harbour.webpirate.service";
const QString DefaultBrowser::OPEN_URL = "open-url.desktop";

DefaultBrowser::DefaultBrowser(QObject *parent) : QObject(parent)
{
    this->_enabled = this->localOpenUrlExists() && this->localServiceExists();
}

bool DefaultBrowser::enabled() const
{
    return this->_enabled;
}

void DefaultBrowser::setEnabled(bool b)
{
    if(this->_enabled == b)
        return;

    this->_enabled = b;

    if(b)
    {
        this->writeLocalService();
        this->writeLocalOpenUrl();
    }
    else
    {
        this->deleteLocalService();
        this->deleteLocalOpenUrl();
    }

    emit enabledChanged();
}

bool DefaultBrowser::localServiceExists() const
{
    QDir localdbusdir = this->localDBusDirectory();

    if(localdbusdir.path() == ".")
        return false;

    return localdbusdir.exists(DefaultBrowser::LOCAL_SERVICE);
}

bool DefaultBrowser::localOpenUrlExists() const
{
    QDir localappssdir = this->localApplicationsDirectory();

    if(localappssdir.path() == ".")
        return false;

    return localappssdir.exists(DefaultBrowser::OPEN_URL);
}

QDir DefaultBrowser::localDBusDirectory() const
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

    if(!dir.cd("dbus-1"))
        return QDir();

    if(!dir.cd("services"))
        return QDir();

    return dir;
}

QDir DefaultBrowser::localApplicationsDirectory() const
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

    if(dir.cd("applications"))
        return dir;

    return QDir();
}

void DefaultBrowser::writeLocalService() const
{
    QDir localdbusdir = this->localDBusDirectory();

    if(localdbusdir.path() == ".")
    {
        QString localpath = QString("%1%2%3").arg("dbus-1", QDir::separator(), "services");

        localdbusdir = QDir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

        localdbusdir.mkpath(localpath);
        localdbusdir.cd(localpath);
    }

    if(localdbusdir.exists(DefaultBrowser::LOCAL_SERVICE)) // Don't write local service twice!
        return;

    QFile f(localdbusdir.absoluteFilePath(DefaultBrowser::LOCAL_SERVICE));
    f.open(QFile::WriteOnly);

    f.write(QString("[D-Bus Service]\n"
                    "Name=org.harbour.webpirate\n"
                    "Exec=/usr/bin/invoker -s --type=silica-qt5 /usr/bin/harbour-webpirate\n").toUtf8());

    f.close();
}

void DefaultBrowser::writeLocalOpenUrl() const
{
    QDir localappsdir = this->localApplicationsDirectory();

    if(localappsdir.path() == ".")
    {
        QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));
        dir.mkdir("applications");
        dir.cd("applications");
    }

    QStringList sysappsdirs = QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation);
    QDir sysappsdir(sysappsdirs.last());
    QFile infile(sysappsdir.absoluteFilePath(DefaultBrowser::OPEN_URL));
    infile.open(QFile::ReadOnly);
    QString content = infile.readAll();
    infile.close();

    content.replace("org.sailfishos.browser", "org.harbour.webpirate");
    QFile outfile(localappsdir.absoluteFilePath(DefaultBrowser::OPEN_URL));
    outfile.open(QFile::WriteOnly);
    outfile.write(content.toUtf8());
    outfile.close();
}

void DefaultBrowser::deleteLocalService() const
{
    QDir localdbusdir = this->localDBusDirectory();

    if(localdbusdir.path() == ".")
        return;

    if(localdbusdir.exists(DefaultBrowser::LOCAL_SERVICE))
        QFile::remove(localdbusdir.absoluteFilePath(DefaultBrowser::LOCAL_SERVICE));

    localdbusdir.setFilter(QDir::NoDot | QDir::NoDotDot);

    if(!localdbusdir.count())
    {
        localdbusdir.cdUp();
        localdbusdir.rmdir("services");

        if(!localdbusdir.count())
        {
            localdbusdir.cdUp();
            localdbusdir.rmdir("dbus-1");
        }
    }
}

void DefaultBrowser::deleteLocalOpenUrl() const
{
    QDir localappsdir = this->localApplicationsDirectory();

    if(localappsdir.path() == ".")
        return;

    if(!localappsdir.exists(DefaultBrowser::OPEN_URL))
            return;

    QFile::remove(localappsdir.absoluteFilePath(DefaultBrowser::OPEN_URL));
}
