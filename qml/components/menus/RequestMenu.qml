import QtQuick 2.0
import Sailfish.Silica 1.0

PopupMenu
{
    signal requestAccepted()
    signal requestRejected()

    id: requestmenu
    popupModel: 1
    anchors.fill: parent

    popupDelegate: Row {
        width: parent.width
        height: Theme.itemSizeSmall

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lblyes
                text: qsTr("Yes");
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                requestmenu.hide();
                requestAccepted();
            }
        }

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lblno
                text: qsTr("No");
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                requestmenu.hide();
                requestRejected();
            }
        }
    }
}
