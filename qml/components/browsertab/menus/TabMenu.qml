import QtQuick 2.1
import Sailfish.Silica 1.0
import "../dialogs"

PopupDialog
{
    property int selectedIndex

    id: tabmenu
    titleVisible: true

    property list<QtObject> tabmenuModel: [ QtObject { readonly property string menuText: qsTr("Duplicate")
                                                       function execute() {
                                                           var tab = tabview.tabAt(selectedIndex);
                                                           tabview.addTab(tab.getUrl(), true, selectedIndex + 1);
                                                       }
                                                      },

                                            QtObject { readonly property string menuText: qsTr("Duplicate in Background")
                                                       function execute() {
                                                           var tab = tabview.tabAt(selectedIndex);
                                                           tabview.addTab(tab.getUrl(), false, selectedIndex + 1);
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Add to Quick Grid")
                                                       function execute() {
                                                           var tab = tabview.tabAt(selectedIndex);
                                                           mainwindow.settings.quickgridmodel.addUrl(tab.getTitle(), tab.getUrl());
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Close")
                                                       function execute() {
                                                           tabview.removeTab(selectedIndex);
                                                       }
                                                     },

                                            QtObject { readonly property string menuText: qsTr("Close other tabs")
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

    popupModel: (tabview.tabs.count > 1 ? tabmenuModel.length : tabmenuModel.length - 2)

    onVisibleChanged: {
        if(!visible)
            return;

        title = tabview.tabAt(selectedIndex).getTitle();
    }

    popupDelegate: ListItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall

        Label {
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: tabmenuModel[index].menuText
        }

        onClicked: {
            tabmenu.hide();
            tabmenuModel[index].execute();
        }
    }
}
