import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property string title
    property alias text: lblcontent.text

    height: lbltitle.height + lblcontent.height

    Label
    {
        id: lbltitle
        anchors { left: parent.left; top: parent.top }
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
        text: title + ":"
    }

    Label
    {
        id: lblcontent
        anchors { left: parent.left; top: lbltitle.bottom }
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.fontSizeExtraSmall
    }
}
