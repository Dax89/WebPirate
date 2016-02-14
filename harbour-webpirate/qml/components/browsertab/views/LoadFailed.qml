import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../items/cover"

Rectangle
{
    property string errorString
    property bool offline
    property bool crash

    id: loadfailed
    color: "white"

    Component.onCompleted: {
        if(crash)
            webview.reload();
    }

    Image
    {
        id: imgerror
        anchors.centerIn: parent

        source: {
            if(crash)
                return "qrc:///res/processcrash.png";

            if(offline)
                return "qrc:///res/noconnection.png";

            return "qrc:///res/loaderror.png";
        }
    }

    Text
    {
        id: txterror
        anchors { top: imgerror.bottom; left: parent.left; right: parent.right; topMargin: Theme.paddingMedium }

        text: {
            if(crash)
                return qsTr("WebView process has crashed, restarting...");

            if(offline)
                return qsTr("You are in offline mode");

            return errorString;
        }

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    PageCoverActions
    {
        id: pagecoveractions
        enabled: loadfailed.visible
    }
}
