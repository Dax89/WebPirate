import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../../js/YouTubeGrabber.js" as YouTubeGrabber

Item
{
    property alias progressMinimum: videoprogress.minimumValue
    property alias progressMaximum: videoprogress.maximumValue
    property alias progressValue: videoprogress.value
    property alias bufferMinimum: bufferprogress.minimumValue
    property alias bufferMaximum: bufferprogress.maximumValue
    property alias bufferValue: bufferprogress.value

    signal seekRequested(int seekpos)

    id: mbprogressbar
    height: 18

    Label
    {
        id: lblcurrentprogress
        anchors { left: parent.left; verticalCenter: progresscontainer.verticalCenter }
        text: YouTubeGrabber.displayDuration(Math.floor(videoprogress.value / 1000.0))
        font.pixelSize: Theme.fontSizeSmall
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle
    {
        id: progresscontainer
        anchors { left: lblcurrentprogress.right; right: lblduration.left; top: parent.top; bottom: parent.bottom; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        color: "white"

        LoadingBar
        {
            id: videoprogress
            anchors.fill: parent
            barHeight: mbprogressbar.height
            z: 1
        }

        LoadingBar
        {
            id: bufferprogress
            anchors.fill: parent
            barColor: "yellow"
            barHeight: mbprogressbar.height
        }

        MouseArea
        {
            anchors.fill: parent
            z: 2

            onClicked: {
                var seekpos = Math.floor(((videoprogress.maximumValue - videoprogress.minimumValue) / videoprogress.width) * mouse.x);
                seekRequested(seekpos);
            }
        }
    }

    Label
    {
        id: lblduration
        anchors { right: parent.right; verticalCenter: progresscontainer.verticalCenter }
        text: YouTubeGrabber.displayDuration(Math.floor(videoprogress.maximumValue / 1000.0))
        font.pixelSize: Theme.fontSizeSmall
        verticalAlignment: Text.AlignVCenter
    }
}
