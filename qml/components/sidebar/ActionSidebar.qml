import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database

Item
{
    id: sidebar
    visible: false
    width: visible ? (mainpage.isPortrait ? parent.width * 0.55 : parent.height * 0.80) : 0
    z: 2

    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
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
                text: qsTr("Favorites")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/favorite/FavoritesPage.qml"), { "folderId": 0, "tabview": tabview, "rootPage": pageStack.currentPage });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-time"
                text: qsTr("Navigation History")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/history/NavigationHistoryPage.qml"), { "tabView": tabview });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-cloud-download"
                text: qsTr("Downloads")
                circleVisible: true
                circleText: mainwindow.settings.downloadmanager.count
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/downloadmanager/DownloadsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-tab"
                text: qsTr("Closed Tabs")
                circleVisible: true
                enabled: tabview.closedtabs.count > 0
                circleText: tabview.closedtabs.count
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/closedtabs/ClosedTabsPage.qml"), { "tabView": tabview });
            }

            SectionHeader
            {
                id: sessionsection
                text: qsTr("Sessions")
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-device-download"
                text: qsTr("Save Session")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/session/SaveSessionPage.qml"), { "tabView": tabview });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-device-upload"
                text: qsTr("Load Session")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/session/SessionSettingsPage.qml"), { "tabView": tabview });
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
                    Database.set("blockads", switchItem.checked ? 1 : 0);
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
                text: qsTr("Change settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/SettingsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-tabs"
                text: qsTr("Popup Blocker")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/popupblocker/PopupManagerPage.qml"));
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-device"
                text: qsTr("Cover settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/cover/CoverSettingsPage.qml"), { "settings": mainwindow.settings });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-m-about"
                text: qsTr("About Web Pirate")
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
