import QtQuick 2.1
import Sailfish.Silica 1.0

ListItem
{
    property alias icon: imgfavicon.source
    property alias domain: lbldomain.text

    Row
    {
        spacing: Theme.paddingSmall
        anchors.fill: parent

        Image
        {
            id: imgfavicon
            width: lbldomain.contentHeight
            height: lbldomain.contentHeight
            fillMode: Image.PreserveAspectFit
        }

        Label
        {
            id: lbldomain
            width: parent.width - imgfavicon.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }
    }
}
