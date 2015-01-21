import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem
{
    property alias circleVisible: circle.visible
    property alias icon: imgaction.source
    property alias text: lblaction.text

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
            visible: false

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

    onClicked: sidebar.collapse()
}
