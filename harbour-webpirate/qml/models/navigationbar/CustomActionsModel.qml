import QtQuick 2.1

Item
{
    property alias actionmodel: customactionsmodel.children

    signal homePageRequested();
    signal nightModeRequested();
    signal closedTabsRequested();
    signal favoritesRequested();
    signal downloadsRequested();
    signal navigationHistoryRequested();
    signal sessionsRequested();
    signal cookiesRequested();

    function execute(idx)  {
        if((idx <= 0) || (idx >= actionmodel.length))
            return;

        actionmodel[idx].execute();
    }

    id: customactionsmodel

    children: [ Item { readonly property string name: qsTr("No Action")
                       readonly property string icon: ""
                       function execute() { /* NOP */ }
                     },

                Item { readonly property string name: qsTr("Home Page")
                       readonly property string icon: "image://theme/icon-m-home"
                       function execute() { homePageRequested(); }
                     },

                Item { readonly property string name: qsTr("Night Mode")
                       readonly property string icon: "qrc:///res/nightmode.png"
                       function execute() { nightModeRequested(); }
                     },

                Item { readonly property string name: qsTr("Closed Tabs")
                       readonly property string icon: "image://theme/icon-m-close"
                       function execute() { closedTabsRequested(); }
                     },

                Item { readonly property string name: qsTr("Favorites")
                       readonly property string icon: "image://theme/icon-m-favorite-selected"
                       function execute() { favoritesRequested(); }
                     },

                Item { readonly property string name: qsTr("Downloads")
                       readonly property string icon: "image://theme/icon-m-cloud-download"
                       function execute() { downloadsRequested(); }
                     },

                Item { readonly property string name: qsTr("Navigation History")
                       readonly property string icon: "image://theme/icon-m-time-date"
                       function execute() { navigationHistoryRequested(); }
                     },

                Item { readonly property string name: qsTr("Sessions")
                       readonly property string icon: "image://theme/icon-m-levels"
                       function execute() { sessionsRequested(); }
                     },

                Item { readonly property string name: qsTr("Cookies")
                       readonly property string icon: "qrc:///res/cookies.png"
                       function execute() { cookiesRequested(); }
                     } ]
}

