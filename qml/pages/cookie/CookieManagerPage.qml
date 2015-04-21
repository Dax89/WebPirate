import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items/cookie"

Page
{
    property Settings settings

    Component.onCompleted: settings.cookiejar.load()
    Component.onDestruction: settings.cookiejar.unload()

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent

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
                onTextChanged: settings.cookiejar.filter(sffilter.text)
            }
        }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: content.bottom; right: parent.right; bottom: parent.bottom }
            model: settings.cookiejar.domains

            delegate: DomainListItem {
                contentWidth: parent.width
                contentHeight: Theme.itemSizeSmall
                domain: model.modelData
                count: settings.cookiejar.cookieCount(model.modelData)
                icon: settings.icondatabase.provideIcon(model.modelData)
                onClicked: pageStack.push(Qt.resolvedUrl("CookieListPage.qml"), { "settings": settings, "domain": model.modelData })
            }
        }
    }
}
