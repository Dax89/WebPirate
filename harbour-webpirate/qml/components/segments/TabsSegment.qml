import QtQuick 2.1
import Sailfish.Silica 1.0
import "../items/tab"

SilicaListView
{
    function load() { }
    function unload() { }

    PullDownMenu
    {
        MenuItem
        {
            text: qsTr("Settings")
            onClicked: pageStack.push(Qt.resolvedUrl("../../pages/settings/SettingsPage.qml"), { "settings": settings })
        }

        MenuItem
        {
            text: qsTr("New Tab")

            onClicked: {
                tabView.addTab(settings.homepage);
                pageStack.pop();
            }
        }
    }

    id: tabssegment
    spacing: Theme.paddingMedium
    clip: true
    model: tabView.tabs

    header: PageHeader {
        id: pageheader
        title: qsTr("Tabs")
    }

    delegate: TabListItem {
        property var tab: tabView.tabAt(model.index)

        contentWidth: tabssegment.width
        contentHeight: Theme.itemSizeExtraLarge
        highlighted: model.index === tabView.currentIndex
        webview: tab ? tab.webView : null
        labelTitle: tab ? tab.title : ""

        onCloseRequested: tabView.removeTab(model.index)

        onClicked: {
            tabView.currentIndex = index;
            pageStack.pop();
        }
    }
}
