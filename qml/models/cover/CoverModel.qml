import QtQuick 2.0
import "../../js/Database.js" as Database
import "../../js/Credentials.js" as Credentials
import "../../js/History.js" as History
import "../../js/Cover.js" as Cover

Item
{
    property alias actionmodel: covermodel.children

    readonly property int generalCategoryId: 0
    readonly property int webPageCategoryId: 1

    property int generalLeftAction: 0
    property int generalRightAction: 1
    property int webPageLeftAction: 0
    property int webPageRightAction: 1

    function selectedLeftAction(categoryid)
    {
        if(categoryid === webPageCategoryId)
            return webPageLeftAction;

        return generalLeftAction;
    }

    function selectedRightAction(categoryid)
    {
        if(categoryid === webPageCategoryId)
            return webPageRightAction;

        return generalRightAction;
    }

    function setLeftAction(categoryid, index)
    {
        if(categoryid === webPageCategoryId)
        {
            webPageLeftAction = index;
            Cover.save(Database.instance(), categoryid, webPageLeftAction, webPageRightAction);
        }
        else
        {
            generalLeftAction = index;
            Cover.save(Database.instance(), categoryid, generalLeftAction, generalRightAction);
        }
    }

    function setRightAction(categoryid, index)
    {
        if(categoryid === webPageCategoryId)
        {
            webPageRightAction = index;
            Cover.save(Database.instance(), categoryid, webPageLeftAction, webPageRightAction);
        }
        else
        {
            generalRightAction = index;
            Cover.save(Database.instance(), categoryid, generalLeftAction, generalRightAction);
        }
    }

    function executeLeftAction(tabview, categoryid)
    {
        var actionidx = selectedLeftAction(categoryid);
        covermodel.children[actionidx].execute(tabview);
    }

    function executeRightAction(tabview, categoryid)
    {
        var actionidx = selectedRightAction(categoryid);
        covermodel.children[actionidx].execute(tabview);
    }

    function leftActionIcon(categoryid)
    {
        var actionidx = selectedLeftAction(categoryid);
        return covermodel.children[actionidx].icon;
    }

    function rightActionIcon(categoryid)
    {
        var actionidx = selectedRightAction(categoryid);
        return covermodel.children[actionidx].icon;
    }

    id: covermodel

    children: [ Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Go to Previous Tab")
                       readonly property string icon: "image://theme/icon-cover-previous"

                       function execute(tabview) {
                           var idx = (tabview.currentIndex - 1) % tabview.pages.count;

                           if(idx < 0)
                               idx = 0;

                           tabview.currentIndex = idx;
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Go to Next Tab")
                       readonly property string icon: "image://theme/icon-cover-next"

                       function execute(tabview) {
                           var idx = (tabview.currentIndex + 1) % tabview.pages.count;

                           if(idx >= tabview.pages.count)
                               idx = tabview.pages.count -1;

                           tabview.currentIndex = idx;
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Add New Tab")
                       readonly property string icon: "image://theme/icon-cover-new"

                       function execute(tabview) {
                           tabview.addTab();
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Close Tab")
                       readonly property string icon: "image://theme/icon-cover-cancel"

                       function execute(tabview) {
                           if(tabview.pages.count <= 1)
                               return;

                           tabview.removeTab(tabview.currentIndex);
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Load Homepage")
                       readonly property string icon: "image://theme/icon-m-home"

                       function execute(tabview) {
                           var tab = tabview.currentTab();
                           tab.load(mainwindow.settings.homepage);
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Close Browser")
                       readonly property string icon: "image://theme/icon-m-cancel"

                       function execute() {
                           Qt.quit();
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Search")
                       readonly property string icon: "image://theme/icon-cover-search"

                       function execute(tabview) {
                           var tab = tabview.currentTab();

                           if(!tab)
                               tab = tabview.addTab();

                           mainwindow.activate();
                           tab.searchRequested();
                       } },

                Item { readonly property int categoryId: webPageCategoryId
                       readonly property string name: qsTr("Reload Current Page")
                       readonly property string icon: "image://theme/icon-cover-refresh"

                       function execute(tabview) {
                           var tab = tabview.currentTab();

                           if(!tab)
                               return;

                           tab.webView.reload();
                       } },

                Item { readonly property int categoryId: generalCategoryId
                       readonly property string name: qsTr("Wipe personal data")
                       readonly property string icon: "image://theme/icon-m-delete"

                       function execute() {
                           webviewdatabase.clearCache();
                           webviewdatabase.clearNavigationData();
                           Credentials.clear(Database.instance());
                           History.clear();
                       } } ]
}
