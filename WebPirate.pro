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
TARGET = WebPirate

CONFIG += sailfishapp

SOURCES += src/WebPirate.cpp

OTHER_FILES += qml/WebPirate.qml \
    qml/cover/CoverPage.qml \
    rpm/WebPirate.changes.in \
    rpm/WebPirate.spec \
    rpm/WebPirate.yaml \
    translations/*.ts \
    WebPirate.desktop \
    qml/js/UrlHelper.js \
    qml/js/SearchEngines.js \
    qml/js/Favorites.js \
    qml/components/TabView.qml \
    qml/components/SearchBar.qml \
    qml/components/NavigationBar.qml \
    qml/components/LoadingBar.qml \
    qml/components/LoadFailed.qml \
    qml/components/FavoritesTab.qml \
    qml/components/ConfirmDialog.qml \
    qml/components/BrowserTab.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/MainPage.qml \
    qml/js/UserAgents.js \
    qml/js/Database.js \
    qml/models/Settings.qml \
    qml/models/FavoritesModel.qml \
    qml/pages/BookmarkPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/WebPirate-de.ts

RESOURCES += \
    resources.qrc

