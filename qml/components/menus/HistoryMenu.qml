import QtQuick 2.1
import Sailfish.Silica 1.0
import "../items/"
import "../../js/History.js" as History

PopupMenu
{
    property string query

    signal urlRequested(string url)

    id: historymenu
    titleVisible: false
    popupModel: ListModel { }

    onQueryChanged: {
        History.match(query, popupModel);

        if(popupModel.count === 0)
        {
            hide();
            return;
        }

        show();
    }

    popupDelegate: PageItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall
        itemTitle: title
        itemText: url
        onClicked: urlRequested(url)

        onPressAndHold: {
            popupmessage.show(qsTr("Link copied to clipboard"));
            Clipboard.text = url;
        }
    }
}
