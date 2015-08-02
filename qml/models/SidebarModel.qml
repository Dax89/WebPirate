import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components/sidebar"

VisualItemModel
{
    id: sidebarmodel

    SectionHeader
    {
        function execute() { /* NOP */ }

        id: generalsection
        text: qsTr("General");
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/favorite/FavoritesPage.qml"), { "folderId": 0, "tabview": tabview, "rootPage": pageStack.currentPage });
            sidebar.collapse();
        }

        id: sifavorites
        highlighted: gesturearea.pressed && (gesturearea.item === sifavorites)
        icon: "image://theme/icon-s-favorite"
        itemText: qsTr("Favorites")
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/session/SessionManagerPage.qml"), { "tabView": tabview });
            sidebar.collapse();
        }

        id: sisessions
        highlighted: gesturearea.pressed && (gesturearea.item === sisessions)
        icon: "image://theme/icon-s-group-chat"
        itemText: qsTr("Sessions")
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/downloadmanager/DownloadsPage.qml"), { "settings": mainwindow.settings });
            sidebar.collapse();
        }

        id: sidownloads
        highlighted: gesturearea.pressed && (gesturearea.item === sidownloads)
        icon: "qrc:///res/download.png"
        itemText: qsTr("Downloads")
        singleItemText: qsTr("Download")
        count: mainwindow.settings.downloadmanager.count
        countVisible: true
    }

    SidebarItem
    {
        function execute() {
            if(!enabled)
                return;

            pageStack.push(Qt.resolvedUrl("../pages/closedtabs/ClosedTabsPage.qml"), { "tabView": tabview });
            sidebar.collapse();
        }

        id: siclosedtabs
        highlighted: enabled && gesturearea.pressed && (gesturearea.item === siclosedtabs)
        icon: "image://theme/icon-m-tab"
        itemText: qsTr("Closed Tabs")
        singleItemText: qsTr("Closed Tab")
        countVisible: true
        count: tabview.closedtabs.count
        enabled: tabview.closedtabs.count > 0
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/history/NavigationHistoryPage.qml"), { "tabView": tabview });
            sidebar.collapse();
        }

        id: sinavigationhistory
        highlighted: gesturearea.pressed && (gesturearea.item === sinavigationhistory)
        icon: "image://theme/icon-s-time"
        itemText: qsTr("Navigation History")
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/cookie/CookieManagerPage.qml"), { "settings": mainwindow.settings });
            sidebar.collapse();
        }

        id: sicookies
        highlighted: gesturearea.pressed && (gesturearea.item === sicookies)
        icon: "qrc:///res/cookies.png"
        itemText: qsTr("Cookies")
    }

    SectionHeader
    {
        function execute() { /* NOP */ }

        id: extensionsection
        text: qsTr("Extensions")
    }

    SidebarSwitch
    {
        text: qsTr("Ad Block")
        switchOnClick: true

        Component.onCompleted: {
            switchItem.checked = mainwindow.settings.adblockmanager.enabled;
        }

        switchItem.onCheckedChanged: {
            mainwindow.settings.adblockmanager.enabled = switchItem.checked;
        }
    }

    SidebarSwitch
    {
        text: qsTr("Night Mode")
        switchOnClick: true

        switchItem.onCheckedChanged: {
            mainwindow.settings.nightmode = switchItem.checked;
        }
    }

    SectionHeader
    {
        function execute() { /* NOP */ }

        id: settingssection
        text: qsTr("Settings")
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/settings/SettingsPage.qml"), { "settings": mainwindow.settings });
            sidebar.collapse();
        }

        id: sisettings
        highlighted: gesturearea.pressed && (gesturearea.item === sisettings)
        icon: "image://theme/icon-s-setting"
        itemText: qsTr("Change settings")
    }

    SidebarItem
    {
        function execute() {
            pageStack.push(Qt.resolvedUrl("../pages/popupblocker/PopupManagerPage.qml"));
            sidebar.collapse();
        }

        id: sipopup
        highlighted: gesturearea.pressed && (gesturearea.item === sipopup)
        icon: "image://theme/icon-m-tabs"
        itemText: qsTr("Popup Blocker")
    }

    SidebarItem
    {
        function execute() {
            var page = pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"), { "settings": mainwindow.settings });

            page.urlRequested.connect(function(url) {
                tabview.addTab(url);
            });

            sidebar.collapse();
        }

        id: siabout
        highlighted: gesturearea.pressed && (gesturearea.item === siabout)
        icon: "image://theme/icon-m-about"
        itemText: qsTr("About Web Pirate")
    }
}
