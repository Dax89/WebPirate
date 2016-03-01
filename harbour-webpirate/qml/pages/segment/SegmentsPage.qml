import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/tabview"
import "../../components/segments"

Page
{
    property int currentSegment: segmentsmodel.tabsSegment
    property Settings settings
    property TabView tabView

    id: segmentspage
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        loader.setSource(Qt.resolvedUrl("../../components/segments/TabsSegment.qml")); // Tabs by default
    }

    onCurrentSegmentChanged: {
        if(currentSegment === segmentsmodel.tabsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/TabsSegment.qml"));
        else if(currentSegment === segmentsmodel.closedTabsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/ClosedTabsSegment.qml"));
        else if(currentSegment === segmentsmodel.favoritesSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/FavoritesSegment.qml"));
        else if(currentSegment === segmentsmodel.downloadsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/DownloadsSegment.qml"));
        else if(currentSegment === segmentsmodel.sessionsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/SessionsSegment.qml"));
        else if(currentSegment === segmentsmodel.historySegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/HistorySegment.qml"));
        else if(currentSegment === segmentsmodel.cookieSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/CookiesSegment.qml"));
        else
            loader.sourceComponent = null;
    }

    SegmentsModel { id: segmentsmodel }

    Item
    {
        anchors.fill: parent

        Loader
        {
            id: loader
            asynchronous: true
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lvsections.top }

            onItemChanged: {
                if(!loader.item)
                    return;

                loader.item.load();
            }
        }

        SilicaListView
        {
            PanelBackground {  anchors.fill: parent; z: -1 }

            id: lvsections
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
            height: Theme.itemSizeSmall + Theme.paddingSmall
            clip: true
            orientation: ListView.Horizontal
            currentIndex: 0
            model: segmentsmodel.elements

            delegate: ListItem {
                readonly property string text: model.text

                width: lvsections.width / 5
                contentHeight: Theme.itemSizeSmall + Theme.paddingSmall

                onClicked: {
                    if(loader.item)
                        loader.item.unload();

                    segmentspage.currentSegment = model.segment;
                    lvsections.currentIndex = model.index;
                }

                Image {
                    id: img
                    source: model.icon
                    width: Theme.iconSizeSmall
                    height: Theme.iconSizeSmall
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: Theme.paddingSmall }
                }

                Label {
                    anchors { left: parent.left; right: parent.right; top: img.bottom; bottom: selectionrect.top; topMargin: Theme.paddingSmall }
                    font.pixelSize: Theme.fontSizeTiny
                    wrapMode: Text.Wrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: model.text
                }

                Rectangle {
                    id: selectionrect
                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                    height: Theme.paddingSmall
                    color: Theme.highlightColor
                    visible: model.index === lvsections.currentIndex
                }
            }
        }
    }
}
