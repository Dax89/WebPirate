import QtQuick 2.1
import Sailfish.Silica 1.0

ListItem
{
    property alias historyTime: lbltime.text
    property alias historyTitle: lbltitle.text
    property alias historyUrl: lblurl.text
    property real titleFont: Theme.fontSizeExtraSmall

    signal openRequested()
    signal openNewTabRequested()
    signal deleteRequested()

    id: navigationhistoryitem

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Open")
            onClicked: openRequested()
        }

        MenuItem {
            text: qsTr("Open in New Tab")
            onClicked: openNewTabRequested()
        }

        MenuItem {
            text: qsTr("Delete")

            onClicked: navigationhistoryitem.remorseAction(qsTr("Deleting item"), function() {
                deleteRequested();
            });
        }
    }

    Row
    {
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        spacing: Theme.paddingSmall

        Label
        {
            id: lbltime
            text: time
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Column
        {
            width: parent.width - lbltime.contentWidth
            height: parent.height

            Label
            {
                id: lbltitle
                text: title
                width: parent.width
                height: parent.height / 2
                font.pixelSize: titleFont
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: Theme.highlightColor
                elide: Text.ElideRight
            }

            Label
            {
                id: lblurl
                text: url
                width: parent.width
                height: parent.height / 2
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }
}
