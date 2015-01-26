import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    property alias labelText: lbltext.text
    property string actionMessage

    signal actionRequested()

    BackgroundItem
    {
        id: backgrounditem
        anchors.fill: parent

        RemorseItem { id: remorseitem }

        Label
        {
            id: lbltext
            anchors.fill: parent
            anchors.leftMargin: Theme.paddingLarge
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: remorseitem.execute(backgrounditem, actionMessage,
                                       function() {
                                           actionRequested();
                                       });
    }
}
