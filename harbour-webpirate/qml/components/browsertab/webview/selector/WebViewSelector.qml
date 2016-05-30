import QtQuick 2.1
import QtGraphicalEffects 1.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

Item
{
    property WebView webView
    readonly property int handleSize: Theme.iconSizeSmall
    readonly property real scaleFactor: webView.experimental.test.contentsScale
    readonly property bool selecting: visible

    function select(selectdata) {
        if(selectdata.start) {
            selector1.x = (selectdata.start.x * scaleFactor) - webView.contentX
            selector1.y = (selectdata.start.y * scaleFactor) - webView.contentY;
        }

        if(selectdata.end) {
            selector2.x = (selectdata.end.x * scaleFactor) - webView.contentX
            selector2.y = (selectdata.end.y * scaleFactor) - webView.contentY;
        }

        visible = selectdata.start || selectdata.end;
        selector1.visible = visible;
        selector2.visible = visible;
    }

    function hide() {
        visible = false;
        selector1.visible = visible;
        selector2.visible = visible;
        webView.postMessage("textselectorhandler_cancel");
    }

    id: webviewselector
    visible: false

    Flickable
    {
        id: flickable
        anchors.fill: parent
        contentX: webView.contentX
        contentY: webView.contentY
        contentWidth: webView.contentWidth
        contentHeight: webView.contentHeight
        pixelAligned: true
    }

    MouseArea
    {
        property int moveThreshold: Theme.paddingMedium
        property int touchAreaSize: Theme.itemSizeExtraSmall
        property bool startSelection: false
        property bool endSelection: false
        readonly property bool hasSelection: startSelection || endSelection
        property real initialMouseX
        property real initialMouseY

        function positionHit(item, mouseX, mouseY) {
            return mouseX > (item.x - touchAreaSize / 2) &&
                   mouseX < ((item.x + item.width) + touchAreaSize / 2) &&
                   mouseY > item.y &&
                   mouseY < ((item.y + item.height) + Math.max(item.height, touchAreaSize));
        }

        function moved(mouseX, mouseY) {
            return (Math.abs(initialMouseX - mouseX) > moveThreshold) ||
                   (Math.abs(initialMouseY - mouseY) > moveThreshold);
        }

        id: mousearea
        parent: flickable
        anchors.fill: parent

        onPressed: {
            startSelection = positionHit(selector1, mouse.x, mouse.y);
            endSelection = positionHit(selector2, mouse.x, mouse.y);

            if(!hasSelection) {
                webviewselector.hide();
                return;
            }

            initialMouseX = mouse.x;
            initialMouseY = mouse.y;
        }

        onReleased: {
            startSelection = endSelection = false;
        }

        onPositionChanged: {
            if(!hasSelection || !moved(mouse.x, mouse.y))
                return;

            var touchdata = { "start": startSelection,
                              "x": mouse.x / webviewselector.scaleFactor,
                              "y": mouse.y / webviewselector.scaleFactor };

            webView.postMessage("textselectorhandler_updateselection", { "touchdata": touchdata });
        }
    }

    SelectorHandle { id: selector1; startHandle: true }
    SelectorHandle { id: selector2 }
}
