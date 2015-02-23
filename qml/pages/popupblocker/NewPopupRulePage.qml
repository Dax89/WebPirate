import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/PopupBlocker.js" as PopupBlocker

Dialog
{
    property alias ruleUrl: tfurl.text
    property alias rule: cbrule.currentIndex

    id: popupruledialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: tfurl.text.length && UrlHelper.isUrl(tfurl.text) && (cbrule.currentIndex > -1)

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader { acceptText: qsTr("Apply Rule") }

            TextField
            {
                id: tfurl
                placeholderText: qsTr("Url")
                width: parent.width
            }

            ComboBox
            {
                id: cbrule
                width: parent.width
                label: qsTr("Rule")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Allow"); }
                    MenuItem { text: qsTr("Block"); }
                }
            }
        }
    }
}
