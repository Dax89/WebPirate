import QtQuick 2.1
import Sailfish.Silica 1.0

ListItem
{
    property alias tabIcon: imgfavicon.source
    property alias tabTitle: lbltitle.text
    property alias tabUrl: lblurl.text

    id: closedtabitem

    signal openRequested()
    signal deleteRequested();

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Open")
            onClicked: openRequested()
        }

        MenuItem {
            text: qsTr("Delete")

            onClicked: {
                closedtabitem.remorseAction(qsTr("Deleting Tab"), function() {
                    deleteRequested();
                });
            }
        }
    }

    Row
    {
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        spacing: Theme.paddingSmall

        Image
        {
            id: imgfavicon
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        Column
        {
            width: parent.width - imgfavicon.width
            height: parent.height

            Label
            {
                id: lbltitle
                text: title
                width: parent.width
                height: parent.height / 2
                font.pixelSize: Theme.fontSizeExtraSmall
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
