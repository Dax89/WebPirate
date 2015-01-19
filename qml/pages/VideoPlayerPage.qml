import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

Page
{
    property alias videoSource: video.source
    allowedOrientations: Orientation.All

    Video
    {
        id: video
        anchors.fill: parent

        MouseArea
        {
            anchors.fill: parent
            onClicked: video.play();
        }
    }
}
