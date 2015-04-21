import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate 1.0
import "../../models"
import "../../components/items/cookie"

Dialog
{
    property Settings settings
    property string domain

    id: dlgcookielist

    SilicaListView
    {
        anchors.fill: parent
        header: PageHeader { id: pageheader; title: qsTr("Cookies") }
        model: settings.cookiejar.getCookies(dlgcookielist.domain)

        delegate: CookieListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            cookieName: model.modelData.name
            cookieDomain: dlgcookielist.domain
        }
    }
}
