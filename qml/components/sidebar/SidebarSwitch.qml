import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property bool switchOnClick: false
    property alias switchItem: switchitem
    property alias text: lblaction.text

    height: Theme.itemSizeExtraSmall
    anchors.leftMargin: Theme.paddingMedium

    onClicked: {
        if(switchOnClick) {
            switchitem.checked = !switchItem.checked;
            return;
        }

        sidebar.collapse();
    }

    Row
    {
        spacing: Theme.paddingSmall
        anchors.fill: parent

        Switch
        {
            id: switchitem
            width: Theme.iconSizeSmall
            height: Theme.iconSizeSmall
            anchors.verticalCenter: parent.verticalCenter
        }

        Label
        {
            id: lblaction
            height: parent.height
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight
        }
    }
}
