import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    signal addRequested()
    signal doneRequested()

    id: quickgridaddbutton
    height: visible ? Theme.itemSizeSmall : 0

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    PanelBackground { anchors.fill: parent }

    Row
    {
        anchors.fill: parent

        Label
        {
            id: lbladd
            width: parent.width / 2
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Add")

            BackgroundItem
            {
                anchors.fill: parent
                onClicked: addRequested()
            }
        }

        Label
        {
            id: lbldone
            width: parent.width / 2
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Done")

            BackgroundItem
            {
                anchors.fill: parent
                onClicked: doneRequested()
            }
        }
    }
}
