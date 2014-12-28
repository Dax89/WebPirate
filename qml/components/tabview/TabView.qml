import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Item
{
    property ListModel pages: ListModel { }
    property real tabWidth: calculateTabWidth()
    property int currentIndex: 0

    id: tabview
    onWidthChanged: calculateTabWidth()
    onCurrentIndexChanged: renderTab()
    Component.onCompleted: renderTab()

    /* BrowserTab Component */
    Component {
        id: tabcomponent
        BrowserTab { }
    }

    function calculateTabWidth()
    {
        if(!pages.count)
            return;

        var stdwidth = (headerrow.width - btnplus.width) / 2;

        if((pages.count * stdwidth) <= headerrow.width)
            tabview.tabWidth = stdwidth;
        else
            tabview.tabWidth = ((headerrow.width - btnplus.width) / pages.count);
    }

    function renderTab()
    {
        for(var i = 0; i < pages.count; i++)
        {
            var tab = pages.get(i).tab;

            if(i == currentIndex)
            {
                tab.visible = true;
                continue;
            }

            tab.visible = false;
        }
    }

    function addTab(url)
    {
        var tab = tabcomponent.createObject(stack);
        tab.anchors.fill = stack

        if(url)
            tab.load(url);

        pages.append({ "tab": tab });
        currentIndex = (pages.count - 1);
        calculateTabWidth();
    }

    function removeTab(idx)
    {
        var tab = pages.get(idx).tab;
        pages.remove(idx);

        tab.parent = null /* Remove Parent Ownership */
        tab.destroy();    /* Destroy the tab immediately */

        if(currentIndex > 0)
            currentIndex--;
        else
            renderTab();

        calculateTabWidth();
    }

    RemorsePopup { id: tabviewremorse }

    Item
    {
        id: header
        anchors { left: parent.left;  right: parent.right; top: parent.top }
        height: Theme.iconSizeMedium

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
                }
            }

            IconButton
            {
                id: btnplus
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                icon.source: "image://theme/icon-m-add"
                anchors.rightMargin: Theme.paddingSmall

                onClicked: tabview.addTab()
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

    Item
    {
        id: container
        anchors { left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom }

        ActionSidebar
        {
            id: sidebar
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        }

        Item
        {
            id: stack
            anchors{ left: sidebar.right; top: parent.top; bottom: parent.bottom }
            width: parent.width
        }
    }

    ShaderEffectSource
    {
        anchors.fill: container
        sourceItem: container
        hideSource: true
    }
}
