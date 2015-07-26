import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    id: sidebar
    visible: false
    width: visible ? (mainpage.isPortrait ? parent.width * 0.55 : parent.height * 0.80) : 0
    z: 20

    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    PanelBackground
    {
        z: -1
        rotation: -90
        anchors.centerIn: parent
        transformOrigin: Item.Center
        width: parent.height
        height: parent.width
    }

    function expand() {
        visible = true;
        tabheader.solidify();
    }

    function collapse() {
        visible = false;
    }

    SilicaFlickable
    {
        id: options
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { flickable: options }

        Column
        {
            id: column
            width: parent.width

            SectionHeader
            {
                id: generalsection
                text: qsTr("General");
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-favorite"
                itemText: qsTr("Favorites")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/favorite/FavoritesPage.qml"), { "folderId": 0, "tabview": tabview, "rootPage": pageStack.currentPage });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-group-chat"
                itemText: qsTr("Sessions")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/session/SessionManagerPage.qml"), { "tabView": tabview });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "qrc:///res/download.png"
                itemText: qsTr("Downloads")
                singleItemText: qsTr("Download")
                count: mainwindow.settings.downloadmanager.count
                countVisible: true
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/downloadmanager/DownloadsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-tab"
                itemText: qsTr("Closed Tabs")
                singleItemText: qsTr("Closed Tab")
                countVisible: true
                count: tabview.closedtabs.count
                enabled: tabview.closedtabs.count > 0
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/closedtabs/ClosedTabsPage.qml"), { "tabView": tabview });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-time"
                itemText: qsTr("Navigation History")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/history/NavigationHistoryPage.qml"), { "tabView": tabview });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "qrc:///res/cookies.png"
                itemText: qsTr("Cookies")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/cookie/CookieManagerPage.qml"), { "settings": mainwindow.settings });
            }

            SectionHeader
            {
                id: extensionsection
                text: qsTr("Extensions")
            }

            SidebarSwitch
            {
                anchors { left: parent.left; right: parent.right }
                text: qsTr("Ad Block")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/adblock/AdBlockPage.qml"), { "settings": mainwindow.settings });

                Component.onCompleted: {
                    switchItem.checked = mainwindow.settings.adblockmanager.enabled;
                }

                switchItem.onCheckedChanged: {
                    mainwindow.settings.adblockmanager.enabled = switchItem.checked;
                }
            }

            SidebarSwitch
            {
                anchors { left: parent.left; right: parent.right }
                text: qsTr("Night Mode")
                switchOnClick: true

                switchItem.onCheckedChanged: {
                    mainwindow.settings.nightmode = switchItem.checked;
                }
            }

            SectionHeader
            {
                id: settingssection
                text: qsTr("Settings")
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-setting"
                itemText: qsTr("Change settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/settings/SettingsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-tabs"
                itemText: qsTr("Popup Blocker")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/popupblocker/PopupManagerPage.qml"));
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-device"
                itemText: qsTr("Cover settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/cover/CoverSettingsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-about"
                itemText: qsTr("About Web Pirate")
                onClicked: {
                    var page = pageStack.push(Qt.resolvedUrl("../../pages/AboutPage.qml"), { "settings": mainwindow.settings });

                    page.urlRequested.connect(function(url) {
                        tabview.addTab(url);
                    });
                }
            }
        }
    }
}
