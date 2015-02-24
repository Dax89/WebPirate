import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property real tabWidth: calculateTabWidth()

    function solidify() {
        tabheader.height = Theme.iconSizeMedium;
        tabheader.opacity = 1.0;
    }

    function evaporate() {
        tabheader.opacity = 0.0;
        tabheader.height = 0;
    }

    function calculateTabWidth()
    {
        if(!pages.count)
            return;

        var stdwidth = (headerrow.width - btnplus.width) / 2;

        if((pages.count * stdwidth) <= headerrow.width)
            tabheader.tabWidth = stdwidth;
        else
            tabheader.tabWidth = ((headerrow.width - btnplus.width) / pages.count);
    }

    id: tabheader
    z: 1
    height: Theme.iconSizeMedium
    color: Theme.rgba(Theme.highlightDimmerColor, 1.0)
    visible: opacity > 0.0
    onWidthChanged: calculateTabWidth()

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    Behavior on opacity {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    Row
    {
        id: headerrow
        anchors { left: parent.left; right: btnsidebar.left; top: parent.top; bottom: parent.bottom }
        spacing: 2

        Repeater
        {
            id: repeater
            model: pages
            anchors { left: parent.left; top: parent.top; right: parent.right }

            delegate: TabButton {
                icon: tab.getIcon();
                title: tab.getTitle();
                loading: tab.state === "webbrowser" && tab.webView.loading
            }
        }

        IconButton
        {
            id: btnplus
            width: Theme.iconSizeMedium
            height: Theme.iconSizeMedium
            icon.source: "image://theme/icon-m-add"
            anchors.rightMargin: Theme.paddingSmall
            onClicked: tabview.addTab(mainwindow.settings.homepage)
        }
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
