import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property list<QtObject> actions: [ QtObject { property string icon: "image://theme/icon-s-favorite";  property string label: qsTr("Favorites") },
                                       QtObject { property string icon: "image://theme/icon-s-cloud-download"; property string label: qsTr("Downloads") },
                                       QtObject { property string icon: "image://theme/icon-s-setting"; property string label: qsTr("Settings") } ]

    id: sidebar
    visible: false
    width: visible ? parent.width * 0.55 : 0
    z: 2

    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    function expand() {
        visible = true;
    }

    function collapse() {
        visible = false;
    }

    SilicaFlickable
    {
        id: options
        clip: true
        anchors.fill: parent

        VerticalScrollDecorator { flickable: options }

        Column
        {
            anchors.fill: parent

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

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/FavoritesPage.qml"), { "folderId": 0, "tabview": tabview, "rootPage": pageStack.currentPage });
            }

            SidebarItem
            {
                anchors { left: parent.left; right: parent.right }
                icon: "image://theme/icon-s-cloud-download"
                text: qsTr("Downloads")
                circleVisible: true

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/DownloadsPage.qml"), { "settings": mainwindow.settings });
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
                icon: "image://theme/icon-m-about"
                text: qsTr("About Web Pirate")

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/AboutPage.qml"), { "settings": mainwindow.settings });
            }
        }
    }
}
