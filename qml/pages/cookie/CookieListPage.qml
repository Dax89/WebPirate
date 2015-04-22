import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate 1.0
import "../../models"
import "../../components/items/cookie"

Page
{
    property DomainListItem domainItem
    property Settings settings
    property string domain

    signal countChanged()

    function loadCookies()
    {
        listview.model = settings.cookiejar.getCookies(pagecookielist.domain);
        countChanged();
    }

    id: pagecookielist
    allowedOrientations: Orientation.All

    SilicaListView
    {
        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Add Cookie")

                onClicked: {
                    var dlgcookie = pageStack.push(Qt.resolvedUrl("CookiePage.qml"), { "settings": pagecookielist.settings, "domain": pagecookielist.domain });

                    dlgcookie.accepted.connect(function() {
                        loadCookies(); // Reload cookies
                    });
                }
            }
        }

        id: listview
        clip: true
        anchors.fill: parent
        header: PageHeader { id: pageheader; title: qsTr("Cookies") }
        Component.onCompleted: loadCookies()

        onCountChanged: {
            if(count > 0)
                return;

            pageStack.pop();
        }

        delegate: CookieListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            cookieName: model.modelData.name
            cookieDomain: pagecookielist.domain

            onClicked: {
                var dlgcookie = pageStack.push(Qt.resolvedUrl("CookiePage.qml"), { "settings": pagecookielist.settings, "cookieItem": model.modelData });

                dlgcookie.accepted.connect(function() {
                    loadCookies(); // Reload cookies
                });
            }
        }
    }
}
