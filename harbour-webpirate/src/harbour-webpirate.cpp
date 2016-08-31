#include <QtQuick>
#include <sailfishapp.h>
#include "dbus/client/machineid.h"
#include "dbus/client/screenblank.h"
#include "dbus/client/urlcomposer.h"
#include "dbus/client/ofono/ofono.h"
#include "dbus/client/transferengine/transferengine.h"
#include "dbus/client/transferengine/transfermethodmodel.h"
#include "dbus/notification/notificationmanager.h"
#include "dbus/webpirateinterface.h"
#include "dbus/defaultbrowser.h"
#include "security/cryptography/aes256.h"
#include "network/networkinterfaces.h"
#include "network/proxymanager.h"
#include "adblock/adblockeditor.h"
#include "adblock/adblockmanager.h"
#include "adblock/adblockdownloader.h"
#include "mime/mimedatabase.h"
#include "webkitdatabase/cookie/cookiejar.h"
#include "webkitdatabase/webkitdatabase.h"
#include "imageproviders/faviconprovider.h"
#include "favoritesmanager/favoritesmanager.h"
#include "downloadmanager/downloadmanager.h"
#include "helper/clipboardhelper.h"
#include "selector/filesmodel.h"
#include "translation/translationsmodel.h"
#include "translation/translationinfoitem.h"

void pluginenv()
{
    QStringList plugins = (QStringList() << "/usr/lib/qt5/plugins" <<
                           (qApp->applicationDirPath() + QDir::separator() + "../share/" + qApp->applicationName() + QDir::separator() + "lib"));

    qputenv("QT_PLUGIN_PATH", plugins.join(":").toUtf8());
}

int main(int argc, char *argv[])
{
    setenv("USE_ASYNC", "1", 1);
    QQuickWindow::setDefaultAlphaBuffer(true);

    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    application->setApplicationName("harbour-webpirate");

    pluginenv();
    ProxyManager::loadAndSet();

    QDBusConnection sessionbus = QDBusConnection::sessionBus();

    if(sessionbus.interface()->isServiceRegistered(WebPirateInterface::INTERFACE_NAME)) // Only a Single Instance is allowed
    {
        WebPirateInterface::sendArgs(application->arguments().mid(1)); // Forward URLs to the running instance

        if(application->hasPendingEvents())
            application->processEvents();

        return 0;
    }

    FilesModel::registerMetaTypes();

    qmlRegisterType<AbstractDownloadItem>("harbour.webpirate.Private", 1, 0, "DownloadItem");
    qmlRegisterType<FavoriteItem>("harbour.webpirate.Private", 1, 0, "FavoriteItem");
    qmlRegisterType<MimeDatabase>("harbour.webpirate.Private", 1, 0, "MimeDatabase");

    qmlRegisterType<TranslationInfoItem>("harbour.webpirate.Translation", 1, 0, "TranslationInfoItem");
    qmlRegisterType<TranslationsModel>("harbour.webpirate.Translation", 1, 0, "TranslationsModel");

    qmlRegisterSingletonType<AES256>("harbour.webpirate.Security", 1, 0, "AES256", &AES256::initialize);
    qmlRegisterSingletonType<NetworkInterfaces>("harbour.webpirate.Network", 1, 0, "NetworkInterfaces", &NetworkInterfaces::initialize);
    qmlRegisterSingletonType<MachineID>("harbour.webpirate.DBus", 1, 0, "MachineID", &MachineID::initialize);
    qmlRegisterSingletonType<Ofono>("harbour.webpirate.DBus", 1, 0, "Ofono", &Ofono::initialize);

    qmlRegisterType<DefaultBrowser>("harbour.webpirate.DBus", 1, 0, "DefaultBrowser");
    qmlRegisterType<WebPirateInterface>("harbour.webpirate.DBus", 1, 0, "WebPirateInterface");
    qmlRegisterType<ScreenBlank>("harbour.webpirate.DBus", 1, 0, "ScreenBlank");
    qmlRegisterType<UrlComposer>("harbour.webpirate.DBus", 1, 0, "UrlComposer");
    qmlRegisterType<NotificationManager>("harbour.webpirate.DBus.Notifications", 1, 0, "Notifications");
    qmlRegisterType<TransferEngine>("harbour.webpirate.DBus.TransferEngine", 1, 0, "TransferEngine");
    qmlRegisterType<TransferMethodModel>("harbour.webpirate.DBus.TransferEngine", 1, 0, "TransferMethodModel");
    qmlRegisterType<ProxyManager>("harbour.webpirate.Network", 1, 0, "ProxyManager");

    qmlRegisterType<AdBlockEditor>("harbour.webpirate.AdBlock", 1, 0, "AdBlockEditor");
    qmlRegisterType<AdBlockDownloader>("harbour.webpirate.AdBlock", 1, 0, "AdBlockDownloader");
    qmlRegisterType<AdBlockManager>("harbour.webpirate.AdBlock", 1, 0, "AdBlockManager");

    qmlRegisterType<CookieJar>("harbour.webpirate.WebKit", 1, 0, "CookieJar");
    qmlRegisterType<WebKitDatabase>("harbour.webpirate.WebKit", 1, 0, "WebKitDatabase");
    qmlRegisterType<WebIconDatabase>("harbour.webpirate.WebKit", 1, 0, "WebIconDatabase");
    qmlRegisterType<DownloadManager>("harbour.webpirate.WebKit", 1, 0, "DownloadManager");

    qmlRegisterType<ClipboardHelper>("harbour.webpirate.Helpers", 1, 0, "ClipboardHelper");
    qmlRegisterType<FilesModel>("harbour.webpirate.Selectors", 1, 0, "FilesModel");
    qmlRegisterType<FavoritesManager>("harbour.webpirate.LocalStorage", 1, 0, "FavoritesManager");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine* engine = view->engine();
    QObject::connect(engine, SIGNAL(quit()), application.data(), SLOT(quit()));

    engine->addImageProvider(WebIconDatabase::PROVIDER_NAME, new FaviconProvider());
    view->setSource(SailfishApp::pathTo("qml/harbour-webpirate.qml"));
    view->show();

    return application->exec();
}
