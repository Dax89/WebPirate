import QtQuick 2.1
import QtGraphicalEffects 1.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

ListItem
{
    property WebView webview
    property bool highlighted: false
    property alias labelTitle: lbltitle.text

    signal closeRequested()

    Connections
    {
        target: webview

        onLoadingChanged: {
            content.refreshNeeded = true; // Set Thumbnail as dirty
        }
    }

    id: tabgriditem
    _showPress: false

    onVisibleChanged: {
        if(!visible || !content.refreshNeeded)
            return;

        thumb.scheduleUpdate();
        content.refreshNeeded = false;
    }

    drag.target: content
    drag.axis: Drag.XAxis
    drag.maximumX: content.width
    drag.minimumX: content.defaultX

    drag.onActiveChanged: {
        if(drag.active)
            return;

        if(content.x > drag.maximumX / 2)
            closeRequested();

        content.x = content.defaultX;
    }

    Item
    {
        readonly property real defaultX: (parent.width / 2) - (width / 2)
        property bool refreshNeeded: false

        id: content
        x: defaultX
        width: Screen.width - (2 * Theme.paddingMedium)
        height: parent.height

        Behavior on x {
            PropertyAnimation { duration: 250; easing.type: Easing.OutBack }
        }

        ShaderEffectSource
        {
            id: thumb
            live: false
            sourceItem: webview ? webview.contentItem : null
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lbltitle.top }
            sourceRect: Qt.rect(0, Theme.paddingSmall, tabgriditem.width, tabgriditem.height)
        }

        LinearGradient
        {
            anchors { fill: parent; topMargin: Theme.paddingSmall }
            source: thumb
            cached: true
            start: Qt.point(parent.width, 0)
            end: Qt.point(parent.width, parent.height)

            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: "black" }
            }
        }

        Label
        {
            id: lbltitle
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeTiny
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            font.bold: highlighted
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
}
