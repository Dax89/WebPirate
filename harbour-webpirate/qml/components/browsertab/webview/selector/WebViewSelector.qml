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
        selector1.x = (selectdata.start.x * scaleFactor) - webView.contentX
        selector1.y = (selectdata.start.y * scaleFactor) - webView.contentY;
        selector2.x = (selectdata.end.x * scaleFactor) - webView.contentX;
        selector2.y = (selectdata.end.y * scaleFactor) - webView.contentY;
        swapSelectors(selectdata.reversed);

        visible = selectdata.start || selectdata.end;
        selector1.visible = visible;
        selector2.visible = visible;
    }

    function hide() {
        visible = false;
        selector1.visible = false;
        selector2.visible = false;

        resetSelectors();
        webView.postMessage("textselectorhandler_cancel");
    }

    function swapSelectors(reversed) {
        selector1.startHandle = reversed ? false : true;
        selector2.startHandle = reversed ? true : false;
    }

    function resetSelectors() {
        selector1.startHandle = true;
        selector2.startHandle = false;
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
            var absoluteX = mouse.x - webView.contentX;
            var absoluteY = mouse.y - webView.contentY;
            //startSelection = positionHit(selector1.startHandle ? selector1 : selector2, absoluteX, absoluteY);
            //endSelection = positionHit(!selector2.startHandle ? selector2 : selector1, absoluteX, absoluteY);
            startSelection = positionHit(selector1, absoluteX, absoluteY);
            endSelection = positionHit(selector2, absoluteX, absoluteY);

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

            var absoluteX = mouse.x - webView.contentX;
            var absoluteY = mouse.y - webView.contentY;

            var touchdata = { "start": startSelection,
                              "reversed": selector2.startHandle,
                              "x": absoluteX / webviewselector.scaleFactor,
                              "y": absoluteY / webviewselector.scaleFactor };

            webView.postMessage("textselectorhandler_updateselection", { "touchdata": touchdata });
        }
    }

    SelectorHandle { id: selector1; startHandle: true }
    SelectorHandle { id: selector2 }
}
