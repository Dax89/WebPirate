import QtQuick 2.1
import Sailfish.Silica 1.0
import ".."
import "../../models"
import "../sidebar"
import "../quickgrid"

Item
{
    property ListModel pages: ListModel { }
    property ClosedTabsModel closedtabs: ClosedTabsModel { }
    property int currentIndex: -1
    property string pageState

    property alias header: tabheader

    id: tabview
    onCurrentIndexChanged: renderTab()
    Component.onCompleted: renderTab()

    onPageStateChanged: {
        if(pageState === "newtab")
            specialitems.requestQuickGrid();
        else if(pageState === "loaderror")
            specialitems.requestLoadFailed();
        else
            specialitems.dismiss();
    }

    /* BrowserTab Component */
    Component {
        id: tabcomponent
        BrowserTab { }
    }

    Connections {
        target: mainpage;

        onOrientationChanged: {
            if(pageState === "webbrowser")
                return;

            specialitems.calculateMetrics();
        }
    }

    Connections {
        target: Qt.inputMethod

        onVisibleChanged: {
            if(pageState === "webbrowser")
                return;

            specialitems.calculateMetrics();
        }
    }

    function renderTab()
    {
        if(currentIndex === -1)
            return;

        for(var i = 0; i < pages.count; i++)
        {
            var tab = pages.get(i).tab;

            if(i === currentIndex)
            {
                tab.webView.setNightMode(mainwindow.settings.nightmode);
                tab.visible = true;
                continue;
            }

            tab.visible = false;
        }
    }

    function addTab(url, foreground)
    {
        if(typeof(foreground) === "undefined")
            foreground = true;

        var tab = tabcomponent.createObject(stack);
        tab.anchors.fill = stack
        tab.visible = foreground;

        if(url)
            tab.load(url);
        else
            tab.loadDefault();

        pages.append({ "tab": tab });

        if(foreground)
            currentIndex = (pages.count - 1);

        tabheader.calculateTabWidth();
        return tab;
    }

    function removeTab(idx)
    {
        var tab = pages.get(idx).tab;
        pages.remove(idx);
        closedtabs.push(tab.getTitle(), tab.getUrl());

        tab.parent = null /* Remove Parent Ownership */
        tab.destroy();    /* Destroy the tab immediately */

        if(currentIndex === -1)
            return;

        if(currentIndex > 0)
            currentIndex--;
        else
            renderTab();

        tabheader.calculateTabWidth();
    }

    function removeAllTabs()
    {
        currentIndex = -1;

        while(pages.count)
            removeTab(0);
    }

    function currentTab()
    {
        var item = pages.get(currentIndex);

        if(!item)
            return null;

        return item.tab;
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
            anchors { left: parent.left; right: parent.right; top: tabheader.bottom; bottom: parent.bottom }
        }

        Item
        {
            id: specialitems
            anchors.top: tabheader.bottom

            function dismiss()
            {
                quickgrid.visible = false;
                loadfailed.visible = false;
            }

            function calculateMetrics()
            {
                var keyboardrect = Qt.inputMethod.keyboardRectangle;

                specialitems.width = stack.width;
                specialitems.height = stack.height - (mainpage.isPortrait ? keyboardrect.height : keyboardrect.width) - Theme.iconSizeMedium;

                if(quickgrid.visible)
                {
                    quickgrid.width = specialitems.width
                    quickgrid.height = specialitems.height
                }
                else if(loadfailed.visible)
                {
                    loadfailed.width = specialitems.width
                    loadfailed.height = specialitems.height
                }
            }

            function requestQuickGrid()
            {
                if(Qt.application.state === Qt.ApplicationActive)
                    tabheader.solidify();

                loadfailed.visible = false;
                quickgrid.visible = true;
            }

            function requestLoadFailed()
            {
                if(Qt.application.state === Qt.ApplicationActive)
                    tabheader.solidify();

                quickgrid.visible = false;
                loadfailed.visible = true;
            }

            QuickGrid
            {
                id: quickgrid
                visible: false
                anchors.top: parent.top
                onLoadRequested: tabview.currentTab().load(request)

                onVisibleChanged: {
                    if(visible)
                        specialitems.calculateMetrics();
                }
            }

            LoadFailed
            {
                id: loadfailed
                anchors.top: parent.top
                visible: false

                onVisibleChanged: {
                    if(visible)
                        specialitems.calculateMetrics();
                }
            }
        }
    }

    ActionSidebar
    {
        id: sidebar
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
    }
}
