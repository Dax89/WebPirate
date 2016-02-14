import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property real tabWidth: mainpage.isPortrait ? tabview.width * 0.45 : tabview.width * 0.35

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
        anchors { left: parent.left; right: buttons.left; top: parent.top; bottom: parent.bottom; rightMargin: Theme.paddingSmall / 2 }
        spacing: Theme.paddingSmall / 2
        clip: true
        model: tabs

        delegate: TabButton {
            width: tabheader.tabWidth
            height: tabheader.height
            icon: tab.getIcon();
            title: tab.getTitle();
            loading: (tab.state === "webbrowser") && tab.webView.loading
        }
    }

    Item
    {
        id: buttons
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
        width: rowcontent.width

        Row
        {
            id: rowcontent

            IconButton
            {
                id: btnplus
                icon.source: "qrc:///res/add.png"
                icon.width: Theme.iconSizeSmall
                icon.height: Theme.iconSizeSmall
                icon.fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                onClicked: tabview.addTab(mainwindow.settings.homepage)
            }

            IconButton
            {
                id: btnsidebar
                icon.source: "image://theme/icon-lock-more"
                icon.width: Theme.iconSizeSmall
                icon.height: Theme.iconSizeSmall
                icon.fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                onClicked: sidebar.visible ? sidebar.collapse() : sidebar.expand()
            }
        }
    }
}
