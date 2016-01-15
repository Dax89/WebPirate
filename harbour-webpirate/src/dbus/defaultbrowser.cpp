#include "defaultbrowser.h"

const QString DefaultBrowser::LOCAL_SERVICE = "org.harbour.webpirate.service";
const QString DefaultBrowser::OPEN_URL = "open-url-webpirate.desktop";

DefaultBrowser::DefaultBrowser(QObject *parent) : QObject(parent), _busy(false), _enabled(false)
{
}

bool DefaultBrowser::busy() const
{
    return this->_busy;
}

void DefaultBrowser::setBusy(bool b)
{
    if(this->_busy == b)
        return;

    this->_busy = b;
    emit busyChanged();
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
        this->writeLocalOpenUrl();
        this->writeLocalService();
        this->overwriteMime();
    }
    else
    {
        this->restoreMime();
        this->deleteLocalService();
        this->deleteLocalOpenUrl();
    }

    emit enabledChanged();
}

bool DefaultBrowser::localOpenUrlExists() const
{
    QDir localappssdir = this->localApplicationsDirectory();

    if(localappssdir.path() == ".")
        return false;

    return localappssdir.exists(DefaultBrowser::OPEN_URL);
}

bool DefaultBrowser::localServiceExists() const
{
    QDir localdbusdir = this->localDBusDirectory();

    if(localdbusdir.path() == ".")
        return false;

    return localdbusdir.exists(DefaultBrowser::LOCAL_SERVICE);
}

bool DefaultBrowser::isMimeOverriden()
{
    bool res = true;
    this->setBusy(true);

    if(this->executeXdgMime("query default text/html") != DefaultBrowser::OPEN_URL)
        res = false;

    if(res && this->executeXdgMime("query default x-maemo-urischeme/http") != DefaultBrowser::OPEN_URL)
        res = false;

    if(res && this->executeXdgMime("query default x-maemo-urischeme/https") != DefaultBrowser::OPEN_URL)
        res = false;

    this->setBusy(false);
    return res;
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

void DefaultBrowser::writeLocalOpenUrl() const
{
    QDir localappsdir = this->localApplicationsDirectory();

    if(localappsdir.path() == ".")
    {
        QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));
        dir.mkdir("applications");
        dir.cd("applications");
    }

    QFile f(localappsdir.absoluteFilePath(DefaultBrowser::OPEN_URL));
    f.open(QFile::WriteOnly);

    f.write(QString("[Desktop Entry]\n"
                    "Type=Application\n"
                    "Name=Browser\n"
                    "NotShownIn=X-MeeGo;\n"
                    "MimeType=text/html;x-maemo-urischeme/http;x-maemo-urischeme/https;\n"
                    "X-Maemo-Service=org.harbour.webpirate\n"
                    "X-Maemo-Method=org.harbour.webpirate.openUrl\n").toUtf8());

    f.close();
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

    f.write(QString("[D-BUS Service]\n"
                    "Name=org.harbour.webpirate\n"
                    "Exec=/usr/bin/invoker -s --type=silica-qt5 /usr/bin/harbour-webpirate\n").toUtf8());

    f.close();
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

void DefaultBrowser::overwriteMime()
{
    this->setBusy(true);

    this->setMime("text/html", DefaultBrowser::OPEN_URL);
    this->setMime("x-maemo-urischeme/http", DefaultBrowser::OPEN_URL);
    this->setMime("x-maemo-urischeme/https", DefaultBrowser::OPEN_URL);

    this->setBusy(false);
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

void DefaultBrowser::restoreMime()
{
    this->setBusy(true);

    this->setMime("text/html", "open-url.desktop");
    this->setMime("x-maemo-urischeme/http", "open-url.desktop");
    this->setMime("x-maemo-urischeme/https", "open-url.desktop");

    this->setBusy(false);
}

QString DefaultBrowser::executeXdgMime(const QString &args)
{
    QProcess xdgmime;
    xdgmime.start(QString("xdg-mime %1").arg(args));
    xdgmime.waitForFinished();

    return QString::fromUtf8(xdgmime.readAllStandardOutput()).simplified();
}

void DefaultBrowser::setMime(const QString &mimetype, const QString &desktopfile)
{
    QDir localappsdir = this->localApplicationsDirectory();

    if(!localappsdir.exists("defaults.list"))
    {
        QProcess symlink;
        symlink.start(QString("ln -sf %1 %2").arg(localappsdir.absoluteFilePath("mimeapps.list"), localappsdir.absoluteFilePath("defaults.list")));
        symlink.waitForFinished();
    }

    this->executeXdgMime(QString("default %1 %2").arg(desktopfile, mimetype));
}

void DefaultBrowser::checkDefaultBrowser()
{
    this->_enabled = this->isMimeOverriden() && this->localServiceExists() && this->localOpenUrlExists();
    emit enabledChanged();
}
