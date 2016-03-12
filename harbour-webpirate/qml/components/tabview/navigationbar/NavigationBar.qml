import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../../"

Rectangle
{
    property alias queryBar: querybar
    readonly property real contentHeight: Theme.itemSizeSmall
    readonly property bool lockHeight: querybar.searchMode

    readonly property WebView webView: {
        var currenttab = tabview.currentTab();

        if(!currenttab)
            return null;

        return currenttab.webView;
    }

    function solidify() {
        height = contentHeight;
    }

    function evaporate() {
        if(lockHeight) { // Disallow evaporation
            solidify();
            return;
        }

        height = 0;
    }

    Behavior on height {
        PropertyAnimation { duration: 250; easing.type: Easing.Linear }
    }

    id: navigationbar
    height: contentHeight
    color: Theme.highlightDimmerColor
    visible: height > 0
    clip: true
    z: 50

    PanelBackground { anchors.fill: parent }

    LoadingBar
    {
        id: loadingbar
        anchors { left: parent.left; top: parent.top; right: parent.right }
        minimumValue: 0
        maximumValue: 100
        value: webView ? webView.loadProgress : 0
        barHeight: navigationbar.height
        barColor: Theme.secondaryHighlightColor
        z: 45
    }

    SilicaFlickable
    {
        property QtObject ngfeffect
        property Item selectedItem: null

        id: content
        anchors.fill: parent
        flickableDirection: Flickable.HorizontalFlick
        z: 50

        boundsBehavior: {
            if(querybar.searchMode || querybar.editing || (!currentTab().viewStack.empty))
                return Flickable.StopAtBounds;

            return Flickable.DragAndOvershootBounds;
        }

        Component.onCompleted: {
            ngfeffect = Qt.createQmlObject("import org.nemomobile.ngf 1.0; NonGraphicalFeedback { event: 'pulldown_highlight' }", content, 'NonGraphicalFeedback');
        }

        onContentXChanged: {
            if(!dragging)
                return;

            if(niback.visible && (contentX < (-niback.width + Theme.paddingSmall))) {
                if(selectedItem !== niback)
                    ngfeffect.play();

                selectedItem = niback;
            }
            else if(niforward.visible && ((contentX + width) > ((niforward.x + niforward.width) - Theme.paddingSmall))) {
                if(selectedItem !== niforward)
                    ngfeffect.play();

                selectedItem = niforward;
            }
            else {
                if(selectedItem)
                    ngfeffect.play();

                selectedItem = null;
            }
        }

        onDraggingChanged: {
            if(dragging || !webView)
                return;

            if(selectedItem === niback)
                webView.goBack();
            else if(selectedItem === niforward)
                webView.goForward();

            selectedItem = null;
        }

        ImageButton
        {
            id: niback
            anchors { right: row.left; top: parent.top; bottom: parent.bottom }
            visible: webView ? webView.canGoBack : false
            width: visible ? parent.height : 0
            highlighted: content.selectedItem === niback
            source: "qrc:///res/back.png"
        }

        Row
        {
            id: row
            anchors.fill: parent

            QueryBar
            {
                id: querybar
                height: Theme.itemSizeMedium
                anchors.verticalCenter: parent.verticalCenter

                width: {
                    var w = parent.width - btntabs.width - (btnpopups.visible ? btnpopups.width : 0);

                    if(searchMode)
                        w -= (btnsearchup.width + btnsearchdown.width + btnshare.width);

                    return w;
                }

                title: {
                    var currenttab = tabview.currentTab();

                    if(!currenttab)
                        return "";

                    return currenttab.title;
                }

                url: {
                    var currenttab = tabview.currentTab();

                    if(!currenttab)
                        return "";

                    return currenttab.webUrl;
                }

                onReturnPressed: {
                    var currenttab = tabview.currentTab();

                    if(!currenttab)
                        return;

                    currenttab.load(searchquery);
                }

                onSearchPressed: webView.experimental.findText(querybar.text, 0xC); /* WebViewExperimental.FindHighlightAllOccurrences |
                                                                                       WebViewExperimental.FindWrapsAroundDocument */

                onTextChanged: {
                    if(!querybar.editing || querybar.searchMode || querybar.displayingText) {
                        tabviewdialogs.hideAll();
                        return;
                    }

                    tabviewdialogs.queryHistory(querybar.text);
                }
            }

            ImageButton
            {
                id: btnsearchup
                source: "image://theme/icon-m-enter-close"
                enabled: querybar.searchMode && (querybar.text.length > 0)
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                rotation: 180
                visible: querybar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xE); /* WebViewExperimental.FindBackward |
                                                                                 WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            ImageButton
            {
                id: btnsearchdown
                source: "image://theme/icon-m-enter-close"
                enabled: querybar.searchMode && (querybar.text.length > 0)
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                visible: querybar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xC); /* WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            ImageButton
            {
                id: btnshare
                source: "image://theme/icon-m-share"
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                visible: querybar.searchMode

                onClicked: {
                    querybar.searchMode = false;

                    var tab = tabview.currentTab();
                    tabviewdialogs.showShareMenu(tab.title, tab.webUrl);
                }
            }

            ImageButton
            {
                id: btnpopups
                source: "qrc:///res/popup.png"
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                visible: {
                    if(querybar.searchMode)
                        return false;

                    var tab = tabview.currentTab();

                    if(!tab)
                        return false;

                    return tab.popups.count > 0;
                }

                onPressAndHold: {
                    var tab = tabview.currentTab();

                    if(!tab)
                        return;

                    tab.popups.clear();
                }

                onClicked: {
                    var tab = tabview.currentTab();
                    pageStack.push(Qt.resolvedUrl("../../../pages/popup/PopupBlockerPage.qml"), { "popupModel": tab.popups, "tabView": tabview });
                }
            }

            ImageButton
            {
                id: btntabs
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                source: {
                    if(querybar.searchMode || !currentTab().viewStack.empty)
                        return "image://theme/icon-close-app";

                    return "image://theme/icon-m-tabs";
                }

                onClicked: {
                    if(querybar.searchMode) {
                        querybar.searchMode = false;
                        webView.experimental.findText("", 0);
                        return;
                    }

                    var tab = currentTab();

                    if(!tab.viewStack.empty) {
                        tab.viewStack.pop();
                        return;
                    }

                    pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings, "tabView": tabview });
                }

                onPressAndHold: {
                    var tab = currentTab();

                    if(querybar.searchMode || (tab.state !== "webview"))
                        return;

                    querybar.searchMode = true;
                }

                Label
                {
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    text: tabview.tabs.count
                    visible: !querybar.searchMode && currentTab().viewStack.empty
                    z: -1
                }
            }
        }

        ImageButton
        {
            id: niforward
            anchors { left: row.right; top: parent.top; bottom: parent.bottom }
            visible: webView ? webView.canGoForward : false
            width: visible ? parent.height : 0
            highlighted: content.selectedItem === niforward
            source: "qrc:///res/forward.png"
        }
    }
}
