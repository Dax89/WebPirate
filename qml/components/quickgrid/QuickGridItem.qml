import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property string itemUrl
    property alias itemTitle: lbltitle.text
    property bool canEdit

    id: quickgriditem

    onItemUrlChanged: {
        imgicon.source = mainwindow.settings.icondatabase.provideIcon(itemUrl);
    }

    Rectangle
    {
        id: thumbnail
        anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lbltitle.top }
        radius: 8
        border.width: 1
        border.color: Theme.secondaryColor
        color: Theme.highlightDimmerColor

        Label
        {
            visible: itemUrl.length === 0
            anchors.centerIn: parent
            text: index + 1
            font.pixelSize: Theme.fontSizeLarge
            font.bold: true
            opacity: 0.7
        }

        Image
        {
            id: imgicon
            width: 64
            height: 64
            cache: false
            visible: itemUrl.length > 0
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }

        QuickGridButton
        {
            id: btnedit
            opacity: canEdit ? 1.0 : 0.0
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
            icon.source: "image://theme/icon-s-edit"

            onClicked: pageStack.push(Qt.resolvedUrl("../../pages/QuickGridPage.qml"), { "settings": mainwindow.settings, "index": index, "title": lbltitle.text, "url": itemUrl })
        }

        QuickGridButton
        {
            id: btndelete
            opacity: canEdit ? 1.0 : 0.0
            anchors { right: parent.right; bottom: parent.bottom; rightMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
            icon.source: "image://theme/icon-close-vkb"
        }
    }

    Label
    {
        id: lbltitle
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        font.pixelSize: Theme.fontSizeTiny
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        clip: true
    }
}
