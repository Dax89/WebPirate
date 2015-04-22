import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../items/cover"

Rectangle
{
    property string errorString
    property bool offline

    id: loadfailed
    color: "white"

    Image
    {
        id: imgerror
        anchors.centerIn: parent
        source: offline ? "qrc:///res/status-offline.png" : "qrc:///res/red-cross-icon.png"
        clip: true
    }

    Text
    {
        id: txterror
        anchors { top: imgerror.bottom; left: parent.left; right: parent.right }
        text: offline ? qsTr("You are in offline mode") : errorString
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    PageCoverActions
    {
        id: pagecoveractions
        enabled: loadfailed.visible
    }
}
