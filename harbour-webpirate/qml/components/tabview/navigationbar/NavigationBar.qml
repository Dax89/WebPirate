import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../../../js/settings/Favorites.js" as Favorites
import "../../../js/UrlHelper.js" as UrlHelper

BrowserBar
{
    readonly property WebView webView: {
        var currenttab = tabview.currentTab();

        if(!currenttab)
            return null;

        return currenttab.webView;
    }

    property alias queryBar: querybar

    id: navigationbar
    extraHeight: loadingbar.height
    lockHeight: querybar.searchMode

    LoadingBar
    {
        id: loadingbar
        anchors { left: parent.left; top: parent.top; right: parent.right }
        minimumValue: 0
        maximumValue: 100
        value: webView ? webView.loadProgress : 0
    }

    SilicaFlickable
    {
        property Item selectedItem: null

        id: content
        anchors.fill: parent
        flickableDirection: Flickable.HorizontalFlick
        boundsBehavior: (querybar.searchMode || querybar.editing) ? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds

        onContentXChanged: {
            if(!dragging)
                return;

            if(niback.visible && (contentX < (-niback.width + Theme.paddingSmall)))
                selectedItem = niback;
            else if(niforward.visible && ((contentX + width) > ((niforward.x + niforward.width) - Theme.paddingSmall)))
                selectedItem = niforward;
            else
                selectedItem = null;
        }

        onDraggingChanged: {
            var tab = currentTab();

            if(dragging || !tab)
                return;

            if(selectedItem === niback)
                tab.goBack();
            else if(selectedItem === niforward)
                tab.goForward();

            selectedItem = null;
        }

        NavigationItem
        {
            id: niback
            anchors { right: row.left; top: parent.top; bottom: parent.bottom }
            visible: currentTab() ? currentTab().canGoBack : false
            width: visible ? parent.height : 0
            highlighted: content.selectedItem === niback
            source: "qrc:///res/back.png"
        }

        Row
        {
            id: row
            anchors.fill: parent
            spacing: Theme.paddingLarge

            QueryBar
            {
                id: querybar
                height: Theme.itemSizeMedium
                anchors.verticalCenter: parent.verticalCenter

                width: {
                    var w = parent.width - (btntabs.width + (Theme.paddingLarge * 2));

                    if(searchMode)
                        w -= (btnsearchup.width + btnsearchdown.width) + (Theme.paddingLarge * 2);

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

            IconButton
            {
                id: btnsearchup
                icon.source: "image://theme/icon-m-enter-close"
                enabled: querybar.searchMode && (querybar.text.length > 0)
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                anchors.verticalCenter: parent.verticalCenter
                rotation: 180
                visible: querybar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xE); /* WebViewExperimental.FindBackward |
                                                                                 WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            IconButton
            {
                id: btnsearchdown
                icon.source: "image://theme/icon-m-enter-close"
                enabled: querybar.searchMode && (querybar.text.length > 0)
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                anchors.verticalCenter: parent.verticalCenter
                visible: querybar.searchMode

                onClicked: webView.experimental.findText(querybar.text, 0xC); /* WebViewExperimental.FindHighlightAllOccurrences |
                                                                                 WebViewExperimental.FindWrapsAroundDocument */
            }

            IconButton
            {
                id: btntabs
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                anchors.verticalCenter: parent.verticalCenter
                icon.source: querybar.searchMode ? "image://theme/icon-close-app" : "image://theme/icon-m-tabs"

                onClicked: {
                    if(querybar.searchMode) {
                        querybar.searchMode = false;
                        webView.experimental.findText("", 0);
                        return;
                    }

                    tabstack.toggleTabs();
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
                    color: btntabs.pressed ? btntabs.icon.highlightColor : Theme.primaryColor
                    text: tabview.tabs.count
                    visible: !querybar.searchMode
                }
            }
        }

        NavigationItem
        {
            id: niforward
            anchors { left: row.right; top: parent.top; bottom: parent.bottom }
            anchors { left: niadd.right; top: parent.top; bottom: parent.bottom }
            visible: currentTab() ? currentTab().canGoForward : false
            width: visible ? parent.height : 0
            highlighted: content.selectedItem === niforward
            source: "qrc:///res/forward.png"
        }
    }
}
