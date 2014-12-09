import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/UrlHelper.js" as UrlHelper
import "../js/Settings.js" as Settings

SilicaListView
{
    signal urlRequested(string favoriteurl)

    id: favoritestab
    clip: true
    model: Settings.favorites

    delegate: ListItem {
        contentHeight: Theme.itemSizeSmall
        width: favoritestab.width

        BackgroundItem {
            id: contentitem
            anchors.fill: parent

            Row {
                anchors.fill: parent
                spacing: Theme.paddingSmall

                FavIcon
                {
                    id: imgfavicon;
                    anchors.verticalCenter: parent.verticalCenter
                    site: Settings.favorites[index].url
                }

                Label {
                    id: lbltitle;
                    height: parent.height
                    width: favoritestab.width - imgfavicon.width
                    text: Settings.favorites[index].title
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    truncationMode: TruncationMode.Fade
                    color: contentitem.down ? Theme.highlightColor : Theme.primaryColor
                }
            }

            onClicked: urlRequested(Settings.favorites[index].url);
        }
    }
}
