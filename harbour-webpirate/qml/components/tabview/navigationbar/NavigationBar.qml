import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../../"
import "../../navigationbar"
import "../../../models"
import "../../../models/navigationbar"

Rectangle
{
    property alias queryBar: querybar
    property alias searchMode: querybar.searchMode
    property bool clipboardMode: false

    readonly property bool normalMode: !searchMode && !clipboardMode
    readonly property real contentHeight: Theme.itemSizeMedium

    readonly property WebView webView: {
        var currenttab = tabview.currentTab();

        if(!currenttab)
            return null;

        return currenttab.webView;
    }

    function search(query) {
        var currenttab = tabview.currentTab();

        if(!currenttab)
            return;

        currenttab.load(query);
    }

    function solidify() {
        height = contentHeight;
    }

    function evaporate() {
        if(!normalMode) { // Disallow evaporation
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

    onClipboardModeChanged: {
        navigationbar.searchMode = false; // States are exclusive

        if(clipboardMode)
            solidify();
    }

    onSearchModeChanged: {
        navigationbar.clipboardMode = false; // States are exclusive

        if(searchMode)
            solidify();
    }

    CustomActionsModel {
        id: customactions

        SegmentsModel { id: segmentsmodel }

        onHomePageRequested: search(settings.homepage)
        onNewTabRequested: tabview.addTab(settings.homepage)
        onCloseCurrentTabRequested: tabview.removeTab(tabview.currentIndex)

        onNightModeRequested: {
            var tab = currentTab();

            if(!tab)
                return;

            tab.switchNightMode();
        }

        onClosedTabsRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.closedTabsSegment });
        }

        onFavoritesRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.favoritesSegment });
        }

        onDownloadsRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.downloadsSegment });
        }

        onNavigationHistoryRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.historySegment });
        }

        onSessionsRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.sessionsSegment });
        }

        onCookiesRequested: {
            pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings,
                                                                                        "tabView": tabview,
                                                                                        "currentSegment": segmentsmodel.cookieSegment });
        }
    }

    BackgroundRectangle { anchors.fill: parent }

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
            if(!normalMode || querybar.editing || (currentTab() && !currentTab().viewStack.empty))
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
                visible: !navigationbar.clipboardMode

                width: {
                    var w = parent.width - btntabsorclose.width;

                    if(btnpopups.visible)
                        w -= btnpopups.width;

                    if(btncustomaction.visible)
                        w -= btncustomaction.width;

                    if(navigationbar.searchMode)
                        w -= (btnsearchup.width + btnsearchdown.width + btnshareorsearch.width);
                    else if(navigationbar.clipboardMode)
                        w -= btnshareorsearch.width;

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

                onReturnPressed: search(searchquery)
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
                id: btncopy
                source: "image://theme/icon-m-clipboard"
                width: querybar.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                visible: navigationbar.clipboardMode

                onClicked: {
                    var tab = tabview.currentTab();
                    tab.getSelectedText(function(text) { settings.clipboard.copy(text); });
                    navigationbar.clipboardMode = false;
                    webView.hideSelectors();
                }
            }

            ImageButton
            {
                id: btnsearchup
                source: "image://theme/icon-m-enter-close"
                enabled: navigationbar.searchMode && (querybar.text.length > 0)
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                rotation: 180
                visible: navigationbar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xE); /* WebViewExperimental.FindBackward |
                                                                                 WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            ImageButton
            {
                id: btnsearchdown
                source: "image://theme/icon-m-enter-close"
                enabled: navigationbar.searchMode && (querybar.text.length > 0)
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                visible: navigationbar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xC); /* WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            ImageButton
            {
                id: btnshareorsearch
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                visible: navigationbar.searchMode || navigationBar.clipboardMode

                source: {
                    if(navigationbar.searchMode)
                        return "image://theme/icon-m-share";

                    if(navigationbar.clipboardMode)
                        return "image://theme/icon-m-search";

                    return "";
                }

                onClicked: {
                    var tab = tabview.currentTab();

                    if(navigationbar.searchMode) // Share
                        tabviewdialogs.showShareMenu(tab.title, tab.webUrl);
                    else if(navigationBar.clipboardMode) { // Search in current tab
                        tab.getSelectedText(function(text) { navigationbar.search(text); });

                        navigationbar.searchMode = false;
                        navigationbar.clipboardMode = false;
                    }
                }

                onPressAndHold: {
                    if(!navigationbar.clipboardMode)
                        return;

                    var tab = tabview.currentTab();
                    tab.getSelectedText(function(text) { tabview.addTab(text, true); });
                    navigationbar.clipboardMode = false;
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
                    if(!navigationBar.normalMode)
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

            ActionButton
            {
                id: btncustomaction
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                customActions: customactions
                pressCustomAction: settings.presscustomaction
                longPressCustomAction: settings.longpresscustomaction
            }

            ImageButton
            {
                id: btntabsorclose
                width: navigationbar.contentHeight
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 2500
                    alwaysRunToEnd: true

                    running: {
                        if(navigationBar.searchMode || navigationBar.clipboardMode || !navigationBar.webView)
                            return false;

                        var tab = currentTab();

                        if(!tab || (tab.state !== "webview"))
                            return false;

                        return navigationBar.webView.loading;
                    }
                }

                source: {
                    if(!navigationBar.normalMode || currentTab() && !currentTab().viewStack.empty)
                        return "image://theme/icon-close-app";

                    return "image://theme/icon-m-tabs";
                }

                onClicked: {
                    if(navigationbar.searchMode) {
                        navigationbar.searchMode = false;
                        webView.experimental.findText("", 0);
                        return;
                    }

                    var tab = currentTab();

                    if(navigationbar.clipboardMode) {
                        tab.cancelSelection();
                        navigationbar.clipboardMode = false;
                        return;
                    }

                    if(!tab.viewStack.empty) {
                        tab.viewStack.pop();
                        return;
                    }

                    pageStack.push(Qt.resolvedUrl("../../../pages/segment/SegmentsPage.qml"), { "settings": settings, "tabView": tabview });
                }

                onPressAndHold: {
                    var tab = currentTab();

                    if(!navigationbar.normalMode || (tab.state !== "webview"))
                        return;

                    navigationbar.searchMode = true;
                }

                Label
                {
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    text: tabview.tabs.count
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: navigationbar.normalMode && currentTab() && currentTab().viewStack.empty
                    rotation: -btntabsorclose.rotation
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
