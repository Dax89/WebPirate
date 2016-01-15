import QtQuick 2.1
import Sailfish.Silica 1.0

WebViewDialog
{
    signal okPressed()

    id: alertdialog
    popupModel: 1

    popupDelegate: BackgroundItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall

        Label {
            id: lblyes
            text: qsTr("Ok");
            anchors.fill: parent
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: {
            alertdialog.hide();
            okPressed();
        }
    }
}
