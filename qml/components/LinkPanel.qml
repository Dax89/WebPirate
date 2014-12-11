import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property string url;
    property bool favorite: false

    signal openLinkRequested(string url)
    signal openTabRequested(string url)
    signal addToFavoritesRequested(string url)
    signal removeFromFavoritesRequested(string url)

    id: linkpage

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.highlightDimmerColor }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.91) }
    }

    onUrlChanged: {
        favorite = mainwindow.settings.favorites.contains(linkpage.url);
    }

    MouseArea
    {
        anchors.fill: parent

        onClicked: {
            linkpage.visible = false;
        }

        Column
        {
            anchors.fill: parent
            width: parent.width

            BackgroundItem
            {
                width: parent.width
                height: Theme.itemSizeSmall

                Label
                {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Open Link")
                }

                onClicked: {
                    linkpage.visible = false;
                    openLinkRequested(linkpage.url)
                }
            }

            BackgroundItem
            {
                width: parent.width
                height: Theme.itemSizeSmall

                Label
                {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Open New Tab");
                }

                onClicked: {
                    linkpage.visible = false;
                    openTabRequested(linkpage.url)
                }
            }

            BackgroundItem
            {
                width: parent.width
                height: Theme.itemSizeSmall

                Label
                {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: favorite ? qsTr("Remove From Favorites") : qsTr("Add To Favorites");
                }

                onClicked: {
                    linkpage.visible = false;

                    if(favorite)
                        removeFromFavoritesRequested(linkpage.url);
                    else
                        addToFavoritesRequested(linkpage.url)
                }
            }
        }
    }
}
