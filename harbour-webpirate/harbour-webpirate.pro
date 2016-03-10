# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-webpirate

QT += sql dbus concurrent
CONFIG += sailfishapp c++11
PKGCONFIG += libcrypto

# Install D-Bus Service (Currently Disabled)
# dbus_service.files = org.browser.WebPirate.service
# dbus_service.path = /usr/share/dbus-1/services
# INSTALLS += dbus_service

# WebP Plugin
webp.files = $$OUT_PWD/../webp-plugin/plugins/imageformats/*.so
webp.path = /usr/share/$$TARGET/lib/imageformats
INSTALLS += webp

SOURCES += src/harbour-webpirate.cpp \
    src/webkitdatabase/webkitdatabase.cpp \
    src/downloadmanager/downloadmanager.cpp \
    src/downloadmanager/downloaditem.cpp \
    src/webkitdatabase/webicondatabase.cpp \
    src/favoritesmanager/favoritesmanager.cpp \
    src/imageproviders/faviconprovider.cpp \
    src/favoritesmanager/favoriteitem.cpp \
    src/dbus/webpirateadaptor.cpp \
    src/mime/mimedatabase.cpp \
    src/adblock/adblockmanager.cpp \
    src/adblock/adblockeditor.cpp \
    src/adblock/adblockfilter.cpp \
    src/adblock/adblockdownloader.cpp \
    src/dbus/client/screenblank.cpp \
    src/security/cryptography/aes256.cpp \
    src/webkitdatabase/cookie/cookiejar.cpp \
    src/webkitdatabase/abstractdatabase.cpp \
    src/downloadmanager/webviewdownloaditem.cpp \
    src/downloadmanager/abstractdownloaditem.cpp \
    src/webkitdatabase/cookie/cookieitem.cpp \
    src/dbus/client/transferengine/transferengine.cpp \
    src/dbus/client/transferengine/transfermethodinfo.cpp \
    src/dbus/client/transferengine/transfermethodmodel.cpp \
    src/dbus/client/urlcomposer.cpp \
    src/dbus/client/ofono/ofono.cpp \
    src/dbus/client/ofono/ofonoproperty.cpp \
    src/network/networkinterfaces.cpp \
    src/dbus/client/machineid.cpp \
    src/dbus/client/notifications/notifications.cpp \
    src/dbus/webpirateinterface.cpp \
    src/downloadmanager/webpagedownloaditem.cpp \
    src/dbus/defaultbrowser.cpp \
    src/network/proxymanager.cpp \
    src/selector/filesmodel.cpp \
    src/selector/filesmodelworker.cpp \
    src/selector/exif/exif.cpp \
    src/helper/clipboardhelper.cpp

OTHER_FILES += qml/harbour-webpirate.qml \
    rpm/harbour-webpirate.spec \
    translations/*.ts \
    harbour-webpirate.desktop \
    qml/js/UrlHelper.js \
    qml/js/settings/SearchEngines.js \
    qml/js/settings/Favorites.js \
    qml/components/tabview/navigationbar/NavigationBar.qml \
    qml/components/browsertab/views/LoadFailed.qml \
    qml/components/browsertab/BrowserTab.qml \
    qml/pages/MainPage.qml \
    qml/js/settings/UserAgents.js \
    qml/js/settings/Database.js \
    qml/models/Settings.qml \
    qml/models/FavoritesModel.qml \
    qml/js/helpers/WebViewHelper.js \
    qml/pages/settings/searchengine/SearchEnginesPage.qml \
    qml/pages/settings/searchengine/SearchEnginePage.qml \
    qml/models/SearchEngineModel.qml \
    qml/js/settings/Credentials.js \
    qml/components/items/DownloadListItem.qml \
    qml/components/browsertab/webview/BrowserWebView.qml \
    qml/js/settings/History.js \
    qml/components/SettingLabel.qml \
    qml/pages/webview/TextSelectionPage.qml \
    qml/components/tabview/TabView.qml \
    qml/components/quickgrid/QuickGrid.qml \
    qml/components/quickgrid/QuickGridItem.qml \
    qml/components/quickgrid/QuickGridButton.qml \
    qml/js/settings/QuickGrid.js \
    qml/models/QuickGridModel.qml \
    qml/components/PopupMessage.qml \
    qml/components/InfoLabel.qml \
    qml/js/youtube/YouTubeGrabber.js \
    qml/components/browsertab/views/browserplayer/mediacomponents/MediaPlayerToolBar.qml \
    qml/components/browsertab/views/browserplayer/mediacomponents/MediaPlayerTitle.qml \
    qml/js/settings/Sessions.js \
    qml/components/items/PageItem.qml \
    qml/components/items/cover/CoverMenu.qml \
    qml/models/cover/CoverModel.qml \
    qml/components/items/cover/PageCoverActions.qml \
    qml/js/settings/Cover.js \
    rpm/harbour-webpirate.yaml \
    qml/js/helpers/NightMode.js \
    qml/js/helpers/ForcePixelRatio.js \
    adblock.css \
    adblock.table \
    qml/components/browsertab/webview/WebViewListener.qml \
    qml/models/HistoryModel.qml \
    qml/components/items/NavigationHistoryItem.qml \
    qml/models/ClosedTabsModel.qml \
    qml/js/settings/PopupBlocker.js \
    qml/models/BlockedPopupModel.qml \
    qml/models/PopupModel.qml \
    qml/components/items/PopupItem.qml \
    qml/components/items/BlockedPopupItem.qml \
    qml/js/helpers/MessageListener.js \
    qml/components/browsertab/ViewStack.qml \
    qml/components/browsertab/views/browserplayer/BrowserPlayer.qml \
    qml/js/helpers/video/YouTubeHelper.js \
    qml/js/helpers/video/VimeoHelper.js \
    qml/js/helpers/video/VideoHelper.js \
    qml/js/helpers/Console.js \
    qml/js/helpers/video/DailyMotionHelper.js \
    qml/js/helpers/GrabberBuilder.js \
    qml/components/browsertab/views/browserplayer/BrowserGrabber.qml \
    qml/components/browsertab/views/browserplayer/mediacomponents/MediaPlayerTimings.qml \
    qml/components/browsertab/views/browserplayer/mediacomponents/MediaPlayerCursor.qml \
    qml/components/browsertab/views/browserplayer/mediacomponents/MediaPlayerProgressBar.qml \
    qml/components/items/cookie/DomainListItem.qml \
    qml/components/items/cookie/CookieListItem.qml \
    qml/components/browsertab/webview/UrlSchemeDelegateHandler.qml \
    qml/js/helpers/video/players/JWPlayerHelper.js \
    qml/js/helpers/Notification.js \
    qml/js/youtube/YouTubeCipher.js \
    qml/pages/settings/SettingsPage.qml \
    qml/pages/settings/GeneralSettingsPage.qml \
    qml/pages/settings/CoverSettingsPage.qml \
    qml/pages/settings/PrivacySettingsPage.qml \
    qml/pages/settings/TabsSettingsPage.qml \
    qml/pages/settings/ExperimentalSettingsPage.qml \
    qml/pages/settings/adblock/AdBlockFilter.qml \
    qml/pages/settings/adblock/AdBlockDownloaderPage.qml \
    qml/pages/settings/adblock/AdBlockPage.qml \
    qml/js/helpers/SystemTextField.js \
    qml/pages/webview/TextFieldPage.qml \
    qml/js/helpers/Utils.js \
    qml/components/quickgrid/QuickGridBottomPanel.qml \
    qml/js/helpers/TOHKBD.js \
    qml/js/polyfills/canvg.min.js \
    qml/pages/settings/ProxySettingsPage.qml \
    qml/components/tabview/TabViewDialogs.qml \
    qml/components/tabview/jsdialogs/AlertDialog.qml \
    qml/components/tabview/jsdialogs/JavaScriptDialog.qml \
    qml/components/tabview/TabStack.qml \
    qml/components/tabview/navigationbar/LoadingBar.qml \
    qml/components/tabview/navigationbar/NavigationItem.qml \
    qml/components/tabview/jsdialogs/ItemSelector.qml \
    qml/components/items/tab/TabListItem.qml \
    qml/components/items/tab/TabClosedItem.qml \
    qml/components/segments/SegmentPool.qml \
    qml/components/segments/TabsSegment.qml \
    qml/components/segments/ClosedTabsSegment.qml \
    qml/components/segments/SessionsSegment.qml \
    qml/components/segments/CookiesSegment.qml \
    qml/models/SegmentsModel.qml \
    qml/components/segments/HistorySegment.qml \
    qml/components/segments/DownloadsSegment.qml \
    qml/components/segments/FavoritesSegment.qml \
    qml/components/items/FavoriteItem.qml \
    qml/menus/FavoritesMenu.qml \
    qml/pages/segment/SegmentsPage.qml \
    qml/pages/segment/favorite/FavoritesImportPage.qml \
    qml/pages/segment/favorite/FavoritePage.qml \
    qml/pages/selector/SelectorFilesPage.qml \
    qml/pages/segment/cookie/CookieListPage.qml \
    qml/pages/segment/cookie/CookiePage.qml \
    qml/pages/segment/session/SaveSessionPage.qml \
    qml/pages/segment/session/SessionPage.qml \
    qml/js/polyfills/es6-collections.min.js \
    qml/components/tabview/jsdialogs/RequestDialog.qml \
    qml/components/DialogBackground.qml \
    qml/components/tabview/jsdialogs/CredentialDialog.qml \
    qml/components/tabview/jsdialogs/FormResubmitDialog.qml \
    qml/components/tabview/jsdialogs/NotificationDialog.qml \
    qml/pages/webview/dialogs/AuthenticationDialog.qml \
    qml/pages/webview/dialogs/ColorChooserDialog.qml \
    qml/pages/webview/dialogs/PromptDialog.qml \
    qml/components/tabview/navigationbar/QueryBar.qml \
    qml/menus/HistoryMenu.qml \
    qml/menus/LinkMenu.qml \
    qml/menus/ShareMenu.qml \
    qml/pages/settings/AboutPage.qml \
    qml/pages/quickgrid/QuickGridPage.qml \
    qml/pages/settings/popup/NewPopupRulePage.qml \
    qml/pages/settings/popup/PopupManagerPage.qml \
    qml/pages/popup/PopupBlockerPage.qml \
    qml/js/helpers/video/FacebookHelper.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-webpirate.ts \
            translations/harbour-webpirate-ca.ts \
            translations/harbour-webpirate-cs_CZ.ts \
            translations/harbour-webpirate-de.ts \
            translations/harbour-webpirate-el.ts \
            translations/harbour-webpirate-es.ts \
            translations/harbour-webpirate-fi_FI.ts \
            translations/harbour-webpirate-fr.ts \
            translations/harbour-webpirate-it.ts \
            translations/harbour-webpirate-ja.ts \
            translations/harbour-webpirate-nl_NL.ts \
            translations/harbour-webpirate-ru_RU.ts \
            translations/harbour-webpirate-sl_SI.ts \
            translations/harbour-webpirate-sv_SE.ts \
            translations/harbour-webpirate-zh_CN.ts \
            translations/harbour-webpirate-zh_TW.ts

RESOURCES += \
    resources.qrc

HEADERS += \
    src/webkitdatabase/webkitdatabase.h \
    src/downloadmanager/downloadmanager.h \
    src/downloadmanager/downloaditem.h \
    src/webkitdatabase/webicondatabase.h \
    src/favoritesmanager/favoritesmanager.h \
    src/imageproviders/faviconprovider.h \
    src/favoritesmanager/favoriteitem.h \
    src/dbus/webpirateadaptor.h \
    src/mime/mimedatabase.h \
    src/adblock/adblockmanager.h \
    src/adblock/adblockeditor.h \
    src/adblock/adblockfilter.h \
    src/adblock/adblockdownloader.h \
    src/dbus/client/screenblank.h \
    src/security/cryptography/aes256.h \
    src/webkitdatabase/cookie/cookiejar.h \
    src/webkitdatabase/abstractdatabase.h \
    src/downloadmanager/webviewdownloaditem.h \
    src/downloadmanager/abstractdownloaditem.h \
    src/webkitdatabase/cookie/cookieitem.h \
    src/dbus/client/transferengine/transferengine.h \
    src/dbus/client/transferengine/transfermethodinfo.h \
    src/dbus/client/transferengine/transfermethodmodel.h \
    src/dbus/client/urlcomposer.h \
    src/dbus/client/ofono/ofono.h \
    src/dbus/client/ofono/ofonoproperty.h \
    src/network/networkinterfaces.h \
    src/dbus/client/machineid.h \
    src/dbus/client/notifications/notifications.h \
    src/dbus/webpirateinterface.h \
    src/downloadmanager/webpagedownloaditem.h \
    src/dbus/defaultbrowser.h \
    src/network/proxymanager.h \
    src/selector/filesmodel.h \
    src/selector/filesmodelworker.h \
    src/selector/exif/exif.h \
    src/helper/clipboardhelper.h

DISTFILES += \
    rpm/harbour-webpirate.changes
