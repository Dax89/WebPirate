import QtQuick 2.1

Item
{
    property alias actionmodel: customactionsmodel.children

    signal homePageRequested();
    signal readerModeRequested();
    signal nightModeRequested();
    signal newTabRequested();
    signal closeCurrentTabRequested();
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
                       readonly property bool webViewOnly: true
                       function execute() { /* NOP */ }
                     },

                Item { readonly property string name: qsTr("Home Page")
                       readonly property string icon: "image://theme/icon-m-home"
                       readonly property bool webViewOnly: false
                       function execute() { homePageRequested(); }
                     },

                Item { readonly property string name: qsTr("Night Mode")
                       readonly property string icon: "qrc:///res/nightmode.png"
                       readonly property bool webViewOnly: false
                       function execute() { nightModeRequested(); }
                     },

                Item { readonly property string name: qsTr("Reader Mode")
                       readonly property string icon: "qrc:///res/reader.png"
                       readonly property bool webViewOnly: true
                       function execute() { readerModeRequested(); }
                     },

                Item { readonly property string name: qsTr("New Tab")
                       readonly property string icon: "qrc:///res/add.png"
                       readonly property bool webViewOnly: false
                       function execute() { newTabRequested(); }
                     },

                Item { readonly property string name: qsTr("Close Current Tab")
                       readonly property string icon: "qrc:///res/close.png"
                       readonly property bool webViewOnly: false
                       function execute() { closeCurrentTabRequested(); }
                     },

                Item { readonly property string name: qsTr("Closed Tabs")
                       readonly property string icon: "image://theme/icon-m-close"
                       readonly property bool webViewOnly: false
                       function execute() { closedTabsRequested(); }
                     },

                Item { readonly property string name: qsTr("Favorites")
                       readonly property string icon: "image://theme/icon-m-favorite-selected"
                       readonly property bool webViewOnly: false
                       function execute() { favoritesRequested(); }
                     },

                Item { readonly property string name: qsTr("Downloads")
                       readonly property string icon: "image://theme/icon-m-cloud-download"
                       readonly property bool webViewOnly: false
                       function execute() { downloadsRequested(); }
                     },

                Item { readonly property string name: qsTr("Navigation History")
                       readonly property string icon: "image://theme/icon-m-time-date"
                       readonly property bool webViewOnly: false
                       function execute() { navigationHistoryRequested(); }
                     },

                Item { readonly property string name: qsTr("Sessions")
                       readonly property string icon: "image://theme/icon-m-levels"
                       readonly property bool webViewOnly: false
                       function execute() { sessionsRequested(); }
                     },

                Item { readonly property string name: qsTr("Cookies")
                       readonly property string icon: "qrc:///res/cookies.png"
                       readonly property bool webViewOnly: false
                       function execute() { cookiesRequested(); }
                     } ]
}

