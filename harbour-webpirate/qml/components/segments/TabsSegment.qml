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
            text: settings.nightmode ? qsTr("Disable Night Mode") : qsTr("Enable Night Mode")

            onClicked: {
                settings.nightmode = !settings.nightmode;
            }
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
    spacing: Theme.paddingSmall
    clip: true
    model: tabView.tabs

    remove: Transition {
        NumberAnimation { property: "x"; duration: 250; to: tabssegment.width * 2; easing.type: Easing.OutBack }
    }

    removeDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 250 }
    }

    header: PageHeader {
        id: pageheader
        title: qsTr("Tabs")
    }

    delegate: TabListItem {
        contentWidth: tabssegment.width
        contentHeight: Theme.itemSizeExtraLarge
        highlighted: model.index === tabView.currentIndex
        tab: tabView.tabAt(model.index)

        onCloseRequested: tabView.removeTab(model.index)

        onClicked: {
            tabView.currentIndex = index;
            pageStack.pop();
        }
    }
}
