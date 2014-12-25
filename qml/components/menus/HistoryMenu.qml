import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database
import "../../js/History.js" as History

MouseArea
{
    property string query

    signal urlRequested(string url)

    function hide() {
        historymenu.hide();
        visible = false;
    }

    PopupMenu
    {
        id: historymenu
        titleVisible: false
        popupModel: ListModel { }

        popupDelegate: ListItem {
            width: parent.width
            height: Theme.itemSizeSmall

            Column {
                anchors.fill: parent

                Label {
                    id: lbltitle
                    width: parent.width
                    height: parent.height / 2
                    color: Theme.secondaryHighlightColor
                    font.bold: true
                    font.family: Theme.fontFamilyHeading
                    font.pixelSize: Theme.fontSizeExtraSmall
                    verticalAlignment: Text.AlignVCenter
                    text: title
                }

                Label {
                    id: lblurl
                    width: parent.width
                    height: parent.height / 2
                    font.pixelSize: Theme.fontSizeExtraSmall
                    verticalAlignment: Text.AlignVCenter
                    text: url
                }
            }

            onClicked: urlRequested(url)
        }
    }

    visible: false
    z: 10

    onClicked: {
        historymenu.popupModel.clear();
        historymenu.hide();
        visible = false
    }

    onQueryChanged: {
        History.match(Database.instance(), query, historymenu.popupModel);

        if(historymenu.popupModel.count === 0)
        {
            hide();
            return;
        }

        visible = true;
        historymenu.show();
    }
}
