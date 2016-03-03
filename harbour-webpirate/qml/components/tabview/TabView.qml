import QtQuick 2.1
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import ".."
import "navigationbar"
import "../../models"
import "../../components/segments"

Item
{
    property alias dialogs: tabviewdialogs
    property alias navigationBar: navigationbar

    property ListModel tabs: ListModel { }
    property ClosedTabsModel closedtabs: ClosedTabsModel { }
    property Component tabComponent: null
    property int currentIndex: -1
    property string pageState

    RemorsePopup { id: tabviewremorse }

    id: tabview
    Component.onCompleted: renderTab()
    onCurrentIndexChanged: renderTab()

    onPageStateChanged: {
        mainwindow.settings.screenblank.enabled = (pageState !== "mediaplayer");

        if(pageState === "newtab")
            tabstack.showQuickGrid();
        else
            tabstack.hideQuickGrid();
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

        var tab = tabComponent.createObject(tabstack.stack, { "tabView": tabview,
                                                              "anchors.fill": tabstack.stack,
                                                              "visible": foreground });

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

    function removeTab(idx, skipnewtab)
    {
        var tab = tabs.get(idx).tab;
        tabs.remove(idx);
        closedtabs.push(tab.title, tab.webUrl);

        if(currentIndex > 0)
            currentIndex--;
        else
            renderTab();

        tab.parent = null /* Remove Parent Ownership */
        tab.destroy();    /* Destroy the tab immediately */

        if(skipnewtab)
            return;

        if(!tabs.count) {
            currentIndex = -1;
            addTab(mainwindow.settings.homepage);
        }
    }

    function removeAllTabs()
    {
        currentIndex = -1;

        while(tabs.count)
            removeTab(0, true);
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

    PopupMessage
    {
        id: popupmessage
        anchors { left: parent.left; top: parent.top; right: parent.right }
    }

    Item
    {
        readonly property real contentHeight: Theme.itemSizeSmall * 5

        id: tabcontainer
        anchors.fill: parent

        TabStack
        {
            id: tabstack
            anchors { left: parent.left; right: parent.right; top: parent.top; bottom: tabviewdialogs.top; topMargin: Theme.paddingSmall }
            dialogsVisible: tabviewdialogs.dialogVisible
            onHideAll: tabviewdialogs.hideAll()
        }

        TabViewDialogs
        {
            id: tabviewdialogs
            anchors { left: parent.left; right: parent.right; bottom: navigationbar.top }
        }

        NavigationBar
        {
            id: navigationbar
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        }
    }
}
