import QtQuick 2.1
import Sailfish.Silica 1.0
import "../dialogs"
import ".."

PopupDialog
{
    property int selectedIndex
    readonly property BrowserTab selectedTab: tabview.tabAt(selectedIndex)

    id: tabmenu
    z: 10
    titleVisible: true

    popupCount: {
        var c = tabmenuModel.length;

        if(!selectedTab || (selectedTab.state !== "webbrowser"))
            c--;

        if((tabview.tabs.count === 1) && !mainwindow.settings.closelasttab)
            c -= 2;

        return c;
    }

    property list<QtObject> tabmenuModel: [ QtObject { readonly property string menuText: qsTr("Duplicate Tab")
                                                       readonly property bool menuVisible: true

                                                       function execute() {
                                                           if(!selectedTab)
                                                               return;

                                                           tabview.addTab(selectedselectedTab.getUrl(), true, selectedIndex + 1);
                                                       }
                                                      },

                                            QtObject { readonly property string menuText: qsTr("Duplicate Tab in Background")
                                                       readonly property bool menuVisible: true

                                                       function execute() {
                                                           if(!selectedTab)
                                                               return;

                                                           tabview.addTab(selectedTab.getUrl(), false, selectedIndex + 1);
                                                       }
                                                     },


                                            QtObject { readonly property string menuText: qsTr("Save page")
                                                       readonly property bool menuVisible: (selectedTab && (selectedTab.state === "webbrowser"))
                                                       function execute() {
                                                           if(!selectedTab)
                                                               return;

                                                           tabviewremorse.execute(qsTr("Downloading web page"), function () {
                                                               selectedTab.webView.experimental.evaluateJavaScript("(function() { return document.documentElement.innerHTML; })()",
                                                                                                      function(result) {
                                                                                                          mainwindow.settings.downloadmanager.createDownloadFromPage(result);
                                                                                                      });
                                                           });
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Add to Quick Grid")
                                                       readonly property bool menuVisible: true

                                                       function execute() {
                                                           if(!selectedTab)
                                                               return;

                                                           mainwindow.settings.quickgridmodel.addUrl(selectedTab.getTitle(), selectedTab.getUrl());
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Close Tab")
                                                       readonly property bool menuVisible: (tabview.tabs.count > 1) || mainwindow.settings.closelasttab

                                                       function execute() {
                                                           if(selectedIndex === -1)
                                                               return;

                                                           tabview.removeTab(selectedIndex);
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Close other Tabs")
                                                       readonly property bool menuVisible: (tabview.tabs.count > 1) || mainwindow.settings.closelasttab

                                                       function execute() {
                                                           var deleteidx = 0;
                                                           var deletedtabs = 0;

                                                           while(tabview.tabs.count > 1)
                                                           {
                                                               if(deletedtabs === selectedIndex)
                                                                   deleteidx++;

                                                               tabview.removeTab(deleteidx);
                                                               deletedtabs++;
                                                           }
                                                       }
                                                     } ]

    popupModel: tabmenuModel

    onVisibleChanged: {
        if(!visible)
            return;

        title = tabview.tabAt(selectedIndex).getTitle();
    }

    popupDelegate: ListItem {
        contentWidth: parent.width
        contentHeight: modelData.menuVisible ? Theme.itemSizeSmall : 0

        Label {
            clip: true
            visible: modelData.menuVisible
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: modelData.menuText
        }

        onClicked: {
            if(!modelData.menuVisible)
                return;

            tabmenu.hide();
            modelData.execute();
        }
    }
}
