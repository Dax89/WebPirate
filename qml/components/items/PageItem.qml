import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem
{
    property alias itemTitle: lbltitle.text
    property alias itemText: lbltext.text

    Column
    {
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }

        Label
        {
            id: lbltitle
            width: parent.width
            height: parent.height / 2
            color: Theme.secondaryHighlightColor
            font.bold: true
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeExtraSmall
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Label
        {
            id: lbltext
            width: parent.width
            height: parent.height / 2
            font.pixelSize: Theme.fontSizeExtraSmall
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
