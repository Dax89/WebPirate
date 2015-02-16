import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/UrlHelper.js" as UrlHelper

Dialog
{
    property alias downloadUrl: tfdownloadurl.text

    id: newdownloadpage
    orientation: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: tfdownloadurl.text.length > 0 && UrlHelper.isUrl(tfdownloadurl.text)

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader { acceptText: qsTr("Start Download") }

            TextField
            {
                id: tfdownloadurl
                width: parent.width
                placeholderText: qsTr("Download Url")
            }
        }
    }
}
