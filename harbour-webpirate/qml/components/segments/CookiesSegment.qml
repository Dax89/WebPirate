import QtQuick 2.1
import Sailfish.Silica 1.0
import "../items/cookie"

SilicaListView
{
    function load() {
        settings.cookiejar.load();
    }

    function unload() {
        settings.cookiejar.unload();
    }

    id: cookiessegment
    clip: true
    model: settings.cookiejar.domains

    delegate: DomainListItem {
        id: domainlistitem
        contentWidth: cookiessegment.width
        contentHeight: Theme.itemSizeSmall
        domain: model.modelData
        count: settings.cookiejar.cookieCount(model.modelData)
        icon: settings.icondatabase.provideIcon(model.modelData)

        onClicked: {
            var cookiepage = pageStack.push(Qt.resolvedUrl("../../pages/segment/cookie/CookieListPage.qml"), { "domainItem": domainlistitem, "settings": settings, "domain": model.modelData });

            cookiepage.countChanged.connect(function() {
                cookiepage.domainItem.count = cookiepage.settings.cookiejar.cookieCount(cookiepage.domain);
            });
        }
    }

    header: Column {
        width: cookiessegment.width

        PageHeader {
            title: qsTr("Cookie Manager")
        }

        SearchField {
            width: parent.width
            placeholderText: qsTr("Filter")
            inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            onTextChanged: settings.cookiejar.filter(text)
        }
    }

    PullDownMenu
    {
        MenuItem
        {
            text: qsTr("Remove All Cookies")
            onClicked: settings.cookiejar.deleteAllCookies();
        }

        MenuItem
        {
            text: qsTr("Add Cookie")
            onClicked: pageStack.push(Qt.resolvedUrl("../../pages/segment/cookie/CookiePage.qml"), { "settings": settings })
        }
    }

    BusyIndicator
    {
        id: busyindicator
        anchors.centerIn: parent
        running: settings.cookiejar.busy
        size: BusyIndicatorSize.Large
    }

    VerticalScrollDecorator { flickable: cookiessegment }
}

