import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"
import "../components/items/"
import "../js/settings/History.js" as History

SilicaListView
{
    property string query

    signal urlRequested(string url)

    function hide() {
        query = "";
        listmodel.clear();
    }

    DialogBackground {
        anchors.fill: parent
    }

    id: historymenu
    verticalLayoutDirection: ListView.BottomToTop
    model: ListModel { id: listmodel }
    visible: count > 0
    clip: true

    onQueryChanged: {
        if(query.trim().length <= 0) {
            listmodel.clear();
            return;
        }

        History.match(query, listmodel, 4)
    }

    delegate: PageItem {
        width: historymenu.width
        contentHeight: Theme.itemSizeSmall
        itemTitle: title
        itemText: url

        onClicked: {
            urlRequested(url);
            hide();
        }

        onPressAndHold: {
            popupmessage.show(qsTr("Link copied to clipboard"));
            mainwindow.settings.clipboard.copy(url);
        }
    }
}
