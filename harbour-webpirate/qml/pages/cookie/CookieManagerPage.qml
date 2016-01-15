import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items/cookie"

Page
{
    property Settings settings

    id: pagecookiemanager
    allowedOrientations: defaultAllowedOrientations
    Component.onDestruction: settings.cookiejar.unload()

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        settings.cookiejar.load();
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent

        RemorsePopup { id: remorsepopup }

        BusyIndicator {
            id: busyindicator
            anchors.centerIn: parent
            running: settings.cookiejar.busy
            size: BusyIndicatorSize.Large
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Remove All Cookies")

                onClicked: {
                    remorsepopup.execute(qsTr("Removing Cookies"), function() {
                        settings.cookiejar.deleteAllCookies();
                    });
                }
            }

            MenuItem {
                text: qsTr("Add Cookie")
                onClicked: pageStack.push(Qt.resolvedUrl("CookiePage.qml"), { "settings": pagecookiemanager.settings })
            }
        }

        Column
        {
            id: content
            width: parent.width

            PageHeader
            {
                id: pagehdr
                title: qsTr("Cookie Manager")
            }

            SearchField
            {
                id: sffilter
                width: parent.width
                placeholderText: qsTr("Filter")
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                onTextChanged: settings.cookiejar.filter(sffilter.text)
            }
        }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: content.bottom; right: parent.right; bottom: parent.bottom }
            model: settings.cookiejar.domains
            quickScroll: true
            clip: true

            VerticalScrollDecorator { flickable: listview }

            delegate: DomainListItem {
                id: domainlistitem
                contentWidth: parent.width
                contentHeight: Theme.itemSizeSmall
                domain: model.modelData
                count: settings.cookiejar.cookieCount(model.modelData)
                icon: settings.icondatabase.provideIcon(model.modelData)

                onClicked: {
                    var cookiepage = pageStack.push(Qt.resolvedUrl("CookieListPage.qml"), { "domainItem": domainlistitem, "settings": settings, "domain": model.modelData });

                    cookiepage.countChanged.connect(function() {
                        cookiepage.domainItem.count = cookiepage.settings.cookiejar.cookieCount(cookiepage.domain);
                    });
                }
            }
        }
    }
}
