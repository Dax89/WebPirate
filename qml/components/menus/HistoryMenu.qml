import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database
import "../../js/History.js" as History

PopupMenu
{
    property string query

    signal urlRequested(string url)

    id: historymenu
    titleVisible: false
    popupModel: ListModel { }

    onQueryChanged: {
        History.match(Database.instance(), query, popupModel);

        if(popupModel.count === 0)
        {
            hide();
            return;
        }

        show();
    }

    popupDelegate: ListItem {
        width: parent.width
        height: Theme.itemSizeSmall

        Column {
            anchors.fill: parent
            anchors.leftMargin: Theme.paddingSmall
            anchors.rightMargin: Theme.paddingSmall

            Label {
                id: lbltitle
                width: parent.width
                height: parent.height / 2
                color: Theme.secondaryHighlightColor
                font.bold: true
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeExtraSmall
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: title
            }

            Label {
                id: lblurl
                width: parent.width
                height: parent.height / 2
                font.pixelSize: Theme.fontSizeExtraSmall
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: url
            }
        }

        onClicked: urlRequested(url)
    }
}
