import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../../js/MediaPlayerHelper.js" as MediaPlayerHelper

Rectangle
{
    readonly property bool busy: imgthumbnail.status !== Image.Ready

    property alias author: lblauthor.text
    property alias title: lbltitle.text
    property alias source: imgthumbnail.source
    property int duration: 0

    id: grabberthumbnail
    height: busy ? Theme.itemSizeExtraLarge : content.height
    color: "black"

    BusyIndicator
    {
        anchors.centerIn: parent
        running: busy
        visible: busy
        size: BusyIndicatorSize.Medium
        z: 3
    }

    Column
    {
        id: content
        width: parent.width

        Row
        {
            id: row
            anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }

            Label
            {
                id: lblauthor
                width: parent.width - lblduration.contentWidth - Theme.paddingMedium
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Theme.fontSizeExtraSmall
                elide: Text.ElideRight
                z: 2
            }

            Label
            {
                id: lblduration
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSizeExtraSmall
                text: MediaPlayerHelper.displayDuration(grabberthumbnail.duration)
                z: 2
            }
        }

        Image
        {
            id: imgthumbnail
            sourceSize.width: Screen.width - (Theme.paddingMedium * 2)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label
        {
            id: lbltitle
            anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
            horizontalAlignment: Text.AlignRight
            font.pixelSize: Theme.fontSizeExtraSmall
            elide: Text.ElideRight
            z: 2
        }
    }
}
