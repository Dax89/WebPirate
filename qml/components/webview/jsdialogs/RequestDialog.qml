import QtQuick 2.1
import Sailfish.Silica 1.0

WebViewDialog
{
    signal requestAccepted()
    signal requestRejected()

    id: requestdialog
    popupModel: 1

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
                requestdialog.hide();
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
                requestdialog.hide();
                requestRejected();
            }
        }
    }
}
