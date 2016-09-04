import QtQuick 2.1
import Sailfish.Silica 1.0
import "../items/tab"

SilicaFlickable
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

    PageHeader
    {
        id: pageheader;
        anchors { left: parent.left; top: parent.top; right: parent.right }
        title: qsTr("Tabs")
    }

    SilicaListView
    {
        id: tabssegment
        anchors { left: parent.left; top: pageheader.bottom; right: parent.right; bottom: parent.bottom }
        verticalLayoutDirection: ListView.BottomToTop
        spacing: Theme.paddingSmall
        model: tabView.tabs
        clip: true

        remove: Transition {
            NumberAnimation { property: "x"; duration: 250; to: tabssegment.width * 2; easing.type: Easing.OutBack }
        }

        removeDisplaced: Transition {
            NumberAnimation { property: "y"; duration: 250 }
        }

        delegate: TabListItem {
            contentWidth: tabssegment.width
            contentHeight: Theme.itemSizeHuge
            highlighted: model.index === tabView.currentIndex
            leftHanded: settings.lefthanded
            tab: tabView.tabAt(model.index)
            onCloseRequested: tabView.removeTab(model.index)

            onClicked: {
                tabView.currentIndex = index;
                pageStack.pop();
            }
        }
    }
}
