import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property real tabWidth: tabview.width * 0.40;

    function solidify() {
        tabheader.height = Theme.iconSizeMedium;
        tabheader.opacity = 1.0;
    }

    function evaporate() {
        tabheader.opacity = 0.0;
        tabheader.height = 0;
    }

    function ensureVisible()
    {        
        listview.positionViewAtIndex(tabview.currentIndex, ListView.Contain);
    }

    id: tabheader
    z: 9
    clip: true
    height: Theme.iconSizeMedium
    color: Theme.rgba(Theme.highlightDimmerColor, 1.0)
    visible: opacity > 0.0

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    Behavior on opacity {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    SilicaListView
    {
        id: listview
        orientation: ListView.Horizontal
        anchors { left: parent.left; right: btnplus.left; rightMargin: Theme.paddingSmall; top: parent.top; bottom: parent.bottom }
        spacing: Theme.paddingSmall / 2
        clip: true
        model: tabs

        delegate: TabButton {
            width: tabheader.tabWidth
            height: tabheader.height + Math.abs(radius)
            icon: tab.getIcon();
            title: tab.getTitle();
            loading: (tab.state === "webbrowser") && tab.webView.loading
        }
    }

    IconButton
    {
        id: btnplus
        icon.source: "image://theme/icon-m-add"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors { top: parent.top; bottom: parent.bottom; right: btnsidebar.left }
        onClicked: tabview.addTab(mainwindow.settings.homepage)
    }

    IconButton
    {
        id: btnsidebar
        icon.source: "image://theme/icon-lock-more"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
        onClicked: sidebar.visible ? sidebar.collapse() : sidebar.expand();
    }
}
