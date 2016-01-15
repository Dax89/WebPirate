import QtQuick 2.1
import Sailfish.Silica 1.0
import ".."
import "../../models"
import "../browsertab/menus"
import "../sidebar"
import "../quickgrid"

Item
{
    property ListModel tabs: ListModel { }
    property ClosedTabsModel closedtabs: ClosedTabsModel { }
    property Component tabComponent: null
    property int currentIndex: -1
    property string pageState

    property alias header: tabheader

    id: tabview
    Component.onCompleted: renderTab()

    onCurrentIndexChanged: {
        tabmenu.hide();
        tabheader.ensureVisible();
        renderTab();
    }

    onPageStateChanged: {
        mainwindow.settings.screenblank.enabled = (pageState !== "mediaplayer");

        if(pageState === "newtab")
            globalitems.requestQuickGrid();
        else
            globalitems.dismiss();
    }

    function renderTab()
    {
        if(currentIndex === -1)
            return;

        for(var i = 0; i < tabs.count; i++)
        {
            var tab = tabs.get(i).tab;

            if(i === currentIndex)
            {
                tab.webView.setNightMode(mainwindow.settings.nightmode);
                tab.visible = true;
                continue;
            }

            tab.visible = false;
        }
    }

    function addTab(url, foreground, insertpos)
    {
        if(typeof(foreground) === "undefined")
            foreground = true;

        if(!tabComponent) {
            tabComponent = Qt.createComponent(Qt.resolvedUrl("../browsertab/BrowserTab.qml"));

            if(tabComponent.status === Component.Error) {
                console.log(tabComponent.errorString());
                return;
            }
        }

        var tab = tabComponent.createObject(stack);
        tab.visible = foreground;

        if(url)
            tab.load(url);

        if(insertpos)
            tabs.insert(insertpos, { "tab": tab });
        else
            tabs.append({ "tab": tab });

        if(foreground)
            currentIndex = insertpos ? insertpos : (tabs.count - 1);

        return tab;
    }

    function removeTab(idx)
    {
        var tab = tabs.get(idx).tab;
        tabs.remove(idx);
        closedtabs.push(tab.getTitle(), tab.getUrl());

        if(currentIndex > 0)
            currentIndex--;
        else
            renderTab();

        tab.parent = null /* Remove Parent Ownership */
        tab.destroy();    /* Destroy the tab immediately */

        if(!tabs.count) {
            currentIndex = -1;
            addTab(mainwindow.settings.homepage);
        }
    }

    function removeAllTabs()
    {
        currentIndex = -1;

        while(tabs.count)
            removeTab(0);
    }

    function tabAt(index)
    {
        if((index < 0) || (index > tabs.count))
            return null;

        var item = tabs.get(index);

        if(!item)
            return null;

        return item.tab;
    }

    function currentTab()
    {
        return tabAt(currentIndex);
    }

    RemorsePopup { id: tabviewremorse }

    PopupMessage
    {
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

        TabMenu
        {
            id: tabmenu
            selectedIndex: tabview.currentIndex
            anchors { left: parent.left; right: parent.right; top: tabheader.bottom; bottom: parent.bottom }
        }

        Item
        {
            id: stack
            anchors { left: parent.left; right: parent.right; top: tabheader.bottom; bottom: parent.bottom }

            onWidthChanged: {
                var tab = currentTab();

                if(tab)
                    tab.calculateWidth();
            }

            onHeightChanged: {
                var tab = currentTab();

                if(tab)
                    tab.calculateHeight();
            }
        }

        Item
        {
            id: globalitems
            anchors { left: parent.left; right: parent.right; top: tabheader.bottom; bottom: parent.bottom; bottomMargin: Theme.iconSizeMedium }
            onWidthChanged: calculateMetrics()
            onHeightChanged: calculateMetrics()

            function dismiss()
            {
                quickgrid.visible = false;
            }

            function calculateMetrics()
            {
                if(!quickgrid.visible)
                    return;

                quickgrid.width = globalitems.width;
                quickgrid.height = globalitems.height;
            }

            function requestQuickGrid()
            {
                if(Qt.application.state === Qt.ApplicationActive)
                    tabheader.solidify();

                quickgrid.disableEditMode();
                quickgrid.visible = true;
            }

            HistoryMenu
            {
                id: historymenu
                anchors.fill: parent
                onUrlRequested: tabview.currentTab().load(url)
            }

            QuickGrid
            {
                id: quickgrid
                visible: false
                anchors.top: parent.top
                onLoadRequested: tabview.currentTab().load(request)

                onVisibleChanged: {
                    if(visible)
                        globalitems.calculateMetrics();
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
