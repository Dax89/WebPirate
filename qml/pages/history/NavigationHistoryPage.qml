import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"
import "../../components/tabview"
import "../../js/History.js" as History

Page
{
    property TabView tabView
    property HistoryModel historyModel: HistoryModel { }

    id: navigationhistorypage
    allowedOrientations: Orientation.All
    Component.onCompleted: History.fetchAll(historyModel);

    RemorsePopup { id: remorsepopup }

    SilicaListView
    {
        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Delete History")

                onClicked: {
                    remorsepopup.execute(qsTr("Deleting History"), function() {
                        History.clear();
                    });
                }
            }
        }

        id: listview
        anchors.fill: parent
        model: historyModel
        section.property: "date"
        section.criteria: ViewSection.FullString

        header: PageHeader {
            title: qsTr("Navigation History")
        }

        section.delegate: Component {
            SectionHeader { text: section; font.pixelSize: Theme.fontSizeExtraSmall; height: Theme.itemSizeExtraSmall }
        }

        delegate: NavigationHistoryItem {
            id: navigationhistoryitem
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
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
                historyModel.remove(index);
            }
        }
    }
}
