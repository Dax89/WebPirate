import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"
import "../../js/settings/History.js" as History

SilicaListView
{
    id: historysegment
    clip: true
    quickScroll: true

    function load() {
        History.fetchAll(historymodel);
    }

    function unload() {
        historymodel.clear();
    }

    PullDownMenu
    {
        MenuItem
        {
            text: qsTr("Delete History")

            onClicked: {
                History.clear();
                historymodel.clear();
            }
        }
    }

    section.property: "date"
    section.criteria: ViewSection.FullString

    section.delegate: Component {
        SectionHeader { text: section; font.pixelSize: Theme.fontSizeSmall; height: Theme.itemSizeExtraSmall }
    }

    header: PageHeader {
        id: pageheader
        title: qsTr("History")
    }

    model: HistoryModel {
        id: historymodel
    }

    delegate: NavigationHistoryItem {
        id: navigationhistoryitem
        contentWidth: historysegment.width
        contentHeight: Theme.itemSizeSmall
        titleFont: Theme.fontSizeSmall
        historyTime: time
        historyTitle: title
        historyUrl: url

        onClicked: {
            tabView.currentTab().load(url);
            pageStack.pop();
        }

        onOpenRequested: {
            tabView.currentTab().load(url);
            pageStack.pop();
        }

        onOpenNewTabRequested: {
            tabView.addTab(url);
            pageStack.pop();
        }

        onDeleteRequested: {
            History.remove(url);
            historymodel.remove(index);
        }
    }


    BusyIndicator
    {
        id: busyindicator
        anchors.centerIn: parent
        running: historymodel.busy
        size: BusyIndicatorSize.Large
    }
}
