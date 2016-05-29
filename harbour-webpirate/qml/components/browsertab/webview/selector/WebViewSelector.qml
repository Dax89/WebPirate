import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0

MouseArea
{
    readonly property bool selecting: webviewselector.visible
    readonly property bool moving: selector1.moving || selector2.moving

    property WebView webView
    property SelectorHandle startHandle
    property SelectorHandle endHandle
    property color handleColor

    function select(selectdata) {
        if(selectdata.start) {
            selector1.x = selectdata.start.x * webView.contentsScale;
            selector1.y = selectdata.start.y * webView.contentsScale;
        }

        if(selectdata.end) {
            selector2.x = selectdata.end.x * webView.contentsScale;
            selector2.y = selectdata.end.y * webView.contentsScale;
        }

        selector1.width = selectdata.size;
        selector1.height = selectdata.size;
        selector2.width = selectdata.size;
        selector2.height = selectdata.size;

        visible = selectdata.start || selectdata.end;
    }

    function hide() {
        visible = false;
        webView.postMessage("textselectorhandler_cancel");
    }

    id: webviewselector
    visible: false
    onClicked: hide()

    SelectorHandle { id: selector1; startHandle: true; color: handleColor }
    SelectorHandle { id: selector2; color: handleColor }
}

