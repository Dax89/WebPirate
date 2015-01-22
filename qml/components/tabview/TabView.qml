import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../sidebar"

Item
{
    property ListModel pages: ListModel { }
    property int currentIndex: 0

    id: tabview
    onCurrentIndexChanged: renderTab()
    Component.onCompleted: renderTab()

    /* BrowserTab Component */
    Component {
        id: tabcomponent
        BrowserTab { }
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
        tabheader.calculateTabWidth();
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

        tabheader.calculateTabWidth();
    }

    RemorsePopup { id: tabviewremorse }

    PopupMessage {
        id: popupmessage
        anchors { left: parent.left; top: parent.top; right: parent.right }
    }

    Item
    {
        id: tabcontainer
        anchors { top: parent.top; bottom: parent.bottom; right: sidebar.left }
        width: parent.width

        TabHeader
        {
            id: tabheader
            anchors { left: parent.left;  right: parent.right; top: parent.top }
        }

        Item
        {
            id: stack
            anchors.fill: parent
        }
    }

    ActionSidebar
    {
        id: sidebar
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
    }
}
