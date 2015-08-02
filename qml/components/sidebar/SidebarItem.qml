import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property bool countVisible: false
    property int count
    property string itemText
    property string singleItemText
    property alias icon: imgaction.source

    id: sidebaritem
    height: Theme.itemSizeExtraSmall

    Row
    {
        spacing: Theme.paddingSmall
        anchors { fill: parent; leftMargin: Theme.paddingMedium }

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
            width: sidebaritem.width - imgaction.width
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight

            text: {
                if(countVisible) {
                    if(count === 1)
                        return count + " " + (singleItemText ? singleItemText : itemText)

                    return count + " " + itemText;
                }

                return itemText;
            }
        }
    }
}
