import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate 1.0
import "../../models"
import "../../components/items/cookie"

Page
{
    property Settings settings
    property string domain

    id: pagecookielist
    allowedOrientations: Orientation.All

    SilicaListView
    {
        anchors.fill: parent
        header: PageHeader { id: pageheader; title: qsTr("Cookies") }
        model: settings.cookiejar.getCookies(pagecookielist.domain)

        delegate: CookieListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            cookieName: model.modelData.name
            cookieDomain: pagecookielist.domain
            onClicked: pageStack.push(Qt.resolvedUrl("CookiePage.qml"), { "settings": settings, "cookieItem": model.modelData })
        }
    }
}
