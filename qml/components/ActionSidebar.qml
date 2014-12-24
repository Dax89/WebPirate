import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property list<QtObject> actions: [ QtObject { property string icon: "image://theme/icon-s-favorite";  property string label: qsTr("Favorites") },
                                       QtObject { property string icon: "image://theme/icon-s-cloud-download"; property string label: qsTr("Downloads") },
                                       QtObject { property string icon: "image://theme/icon-s-setting"; property string label: qsTr("Settings") } ]

    id: sidebar
    visible: false

    signal favoritesRequested()
    signal downloadsRequested()
    signal settingsRequested()

    function expand() {
        width = parent.width / 3;
    }

    function collapse() {
        width = 0;
    }

    Behavior on width {
        NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: actions

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
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label
                    {
                        id: lblaction
                        height: parent.height
                        width: parent.width - imgaction.width
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: label
                        elide: Text.ElideRight
                        clip: true
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

    onWidthChanged: {
        visible = width > 0;
    }
}
