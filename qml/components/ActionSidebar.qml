import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property list<QtObject> actions: [ QtObject { property string icon: "image://theme/icon-s-favorite";  property string label: qsTr("Favorites") },
                                       QtObject { property string icon: "image://theme/icon-s-cloud-download"; property string label: qsTr("Downloads") },
                                       QtObject { property string icon: "image://theme/icon-s-setting"; property string label: qsTr("Settings") } ]

    id: sidebar
    visible: width > 0

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
    }

    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    function expand() {
        sidebar.width = parent.width / 4;
    }

    function collapse() {
        sidebar.width = 0;
    }

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: actions
        clip: true

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
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label
                    {
                        id: lblaction
                        height: parent.height
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: label
                        elide: Text.ElideRight
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

                        Label
                        {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: mainwindow.settings.downloadmanager.count
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.primaryColor
                            elide: Text.ElideRight
                        }
                    }
                }

                onClicked: {
                    if(index === 0)
                        pageStack.push(Qt.resolvedUrl("../pages/FavoritesPage.qml"), { "settings": mainwindow.settings, "tabview": tabview });
                    else if(index === 1)
                        pageStack.push(Qt.resolvedUrl("../pages/DownloadsPage.qml"), { "settings": mainwindow.settings });
                    else if(index === 2)
                        pageStack.push(Qt.resolvedUrl("../pages/SettingsPage.qml"), { "settings": mainwindow.settings });
                }
            }
        }
    }
}
