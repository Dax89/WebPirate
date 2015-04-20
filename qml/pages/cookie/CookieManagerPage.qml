import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"

Page
{
    property Settings settings

    Component.onCompleted: settings.cookiejar.load()
    Component.onDestruction: settings.cookiejar.unload()

    SilicaListView
    {
        anchors.fill: parent
        header: PageHeader { title: qsTr("Cookie Manager")  }
        model: settings.cookiejar.count

        delegate: CookieListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall

            domain: settings.cookiejar.getDomain(index)
            count: settings.cookiejar.cookieCount(domain)
            icon: settings.icondatabase.provideIcon(domain)
        }
    }
}
