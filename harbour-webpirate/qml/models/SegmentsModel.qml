import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    readonly property int tabsSegment: 0
    readonly property int closedTabsSegment: 1
    readonly property int favoritesSegment: 2
    readonly property int downloadsSegment: 3
    readonly property int sessionsSegment: 4
    readonly property int historySegment: 5
    readonly property int cookieSegment: 6

    property list<QtObject> elements: [ QtObject { readonly property int segment: tabsSegment
                                                   readonly property string icon: "image://theme/icon-m-tabs"
                                                   readonly property string text: qsTr("Tabs") },

                                        QtObject { readonly property int segment: closedTabsSegment
                                                   readonly property string icon: "image://theme/icon-m-tab"
                                                   readonly property string text: qsTr("Closed Tabs") },

                                        QtObject { readonly property int segment: favoritesSegment
                                                   readonly property string icon: "image://theme/icon-s-favorite"
                                                   readonly property string text: qsTr("Favorites") },

                                        QtObject { readonly property int segment: downloadsSegment
                                                   readonly property string icon: "qrc:///res/download.png"
                                                   readonly property string text: qsTr("Downloads") },

                                        QtObject { readonly property int segment: sessionsSegment
                                                   readonly property string icon: "image://theme/icon-s-group-chat"
                                                   readonly property string text: qsTr("Sessions") },

                                        QtObject { readonly property int segment: historySegment
                                                   readonly property string icon: "image://theme/icon-s-time"
                                                   readonly property string text: qsTr("History") },

                                        QtObject { readonly property int segment: cookieSegment
                                                   readonly property string icon: "qrc:///res/cookies.png"
                                                   readonly property string text: qsTr("Cookie") } ]
}
