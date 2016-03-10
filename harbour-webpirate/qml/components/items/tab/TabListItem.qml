import QtQuick 2.1
import QtGraphicalEffects 1.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

ListItem
{
    property var tab
    property bool highlighted: false

    signal closeRequested()

    function update() {
        if(!visible || !tab || !tab.thumbUpdated)
            return;

        thumb.scheduleUpdate();
        tab.thumbUpdated = false;
    }

    id: tablistitem
    _showPress: false
    showMenuOnPressAndHold: tab && (tab.state === "webview")
    onVisibleChanged: update()

    drag.target: content
    drag.axis: Drag.XAxis
    drag.maximumX: content.width
    drag.minimumX: content.defaultX

    onWidthChanged: {
        content.x = content.defaultX; // Reposition Item
    }

    drag.onActiveChanged: {
        if(drag.active)
            return;

        if(content.x > ((content.defaultX + content.width) / 2.0))
            closeRequested();

        content.x = content.defaultX;
    }

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Copy link")

            onClicked: {
                popupmessage.show(qsTr("Link copied to clipboard"));
                settings.clipboard.copy(tab.webUrl);
            }
        }

        MenuItem {
            text: qsTr("Save page")

            onClicked: {
                tablistitem.remorseAction(qsTr("Downloading web page"), function () {
                    tab.webView.experimental.evaluateJavaScript("(function() { return document.documentElement.innerHTML; })()",
                                                                function(result) { settings.downloadmanager.createDownloadFromPage(result); }) });
            }
        }

        MenuItem {
            text: qsTr("Duplicate tab")
            onClicked: tabView.addTab(tab.webUrl, false, model.index + 1);
        }
    }

    Connections
    {
        target: tab
        onThumbUpdatedChanged: update()
    }

    Item
    {
        readonly property bool webviewVisible: tab && (tab.state === "webview")
        readonly property real defaultX: (parent.width / 2) - (width / 2)

        id: content
        x: defaultX
        width: Screen.width
        height: parent.height

        Behavior on x { PropertyAnimation { duration: 250; easing.type: Easing.OutBack } }

        Item
        {
            id: effectitem
            anchors.fill: parent

            Rectangle { id: specialthumb; anchors.fill: parent; visible: !content.webviewVisible; color: highlighted ? Theme.secondaryHighlightColor : "gray" }

            ShaderEffectSource
            {
                id: thumb
                anchors.fill: parent
                live: false
                sourceItem: tab ? tab.webView.contentItem : null
                sourceRect: Qt.rect(0, Theme.paddingSmall, content.width, content.height)
                visible: content.webviewVisible
            }
        }

        Desaturate
        {
            anchors.fill: effectitem
            source: effectitem
            desaturation: highlighted ? 0.0 : 1.0
            visible: content.webviewVisible
        }

        LinearGradient
        {
            anchors.fill: effectitem
            start: Qt.point(parent.width, 0)
            end: Qt.point(parent.width, parent.height)

            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: "black" }
            }
        }

        Image
        {
            id: img
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingLarge }
            width: Theme.iconSizeMedium
            height: Theme.iconSizeMedium
            fillMode: Image.PreserveAspectFit

            source: {
                if(!tab)
                    return "";

                if(tab.state === "newtab")
                    return "qrc:///res/quickgrid.png";

                if(tab.state === "loaderror")
                    return "qrc:///res/loaderror_white.png";

                return "";
            }
        }

        Label
        {
            anchors { top: parent.top; bottom: parent.bottom; bottomMargin: Theme.paddingMedium }
            x: Math.max(img.width, parent.width - contentWidth - Theme.paddingMedium)
            width: parent.width - x
            font { family: Theme.fontFamilyHeading; pixelSize: Theme.fontSizeMedium }
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignLeft
            truncationMode: TruncationMode.Fade
            color: highlighted ? Theme.highlightColor : Theme.primaryColor

            text: {
                if(!tab)
                    return "";

                if(tab.state === "newtab")
                    return qsTr("Quick Grid");

                if(tab.state === "loaderror")
                    return qsTr("Load error");

                return tab.title;
            }
        }
    }
}
