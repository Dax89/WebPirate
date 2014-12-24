import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property list<QtObject> actions: [ QtObject { property string icon: "image://theme/icon-s-favorite";  property string label: qsTr("Favorites") },
                                       QtObject { property string icon: "image://theme/icon-s-cloud-download"; property string label: qsTr("Downloads") },
                                       QtObject { property string icon: "image://theme/icon-s-setting"; property string label: qsTr("Settings") } ]

    id: sidebar
    visible: false
    width: parent.width / 3

    Behavior on visible {
        NumberAnimation {
            target: sidebar
            property: "width"
            from: sidebar.visible ? sidebar.width: 0
            to: sidebar.visible ? 0 : sidebar.parent.width / 3

            duration: 100;
            easing.type: Easing.InOutQuad
        }
    }

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: actions

        VerticalScrollDecorator { flickable: listview }

        delegate: Component {
            ListItem {
                width: parent.width
                height: Theme.itemSizeExtraSmall

                Row
                {
                    spacing: Theme.paddingSmall
                    anchors.fill: parent

                    Image
                    {
                        id: imgaction
                        width: Theme.iconSizeSmall
                        height: Theme.iconSizeSmall
                        source: icon
                        clip: true
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label
                    {
                        id: lblaction
                        height: parent.height
                        //width: parent.width - imgaction.width - ((index == 1) ? circle.width : 0)
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: label
                        elide: Text.ElideRight
                        clip: true
                    }

                    Rectangle
                    {
                        id: circle
                        width: Theme.iconSizeSmall
                        height: Theme.iconSizeSmall
                        color: Theme.secondaryHighlightColor
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.verticalCenter: parent.verticalCenter
                        radius: width * 0.5
                        visible: index == 1
                        clip: true

                        Label
                        {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: mainwindow.settings.downloadmanager.count
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.primaryColor
                            elide: Text.ElideRight
                            clip: true
                        }
                    }
                }

                onClicked: {
                    if(index === 0)
                        pageStack.push(Qt.resolvedUrl("../pages/FavoritesPage.qml"), { "settings": mainwindow.settings });
                    else if(index === 1)
                        pageStack.push(Qt.resolvedUrl("../pages/DownloadsPage.qml"), { "settings": mainwindow.settings });
                    else if(index === 2)
                        pageStack.push(Qt.resolvedUrl("../pages/SettingsPage.qml"), { "settings": mainwindow.settings });
                }
            }
        }
    }
}
