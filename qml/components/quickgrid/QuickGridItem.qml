import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property string itemUrl
    property alias itemTitle: lbltitle.text
    property bool specialItem: false
    property bool editEnabled

    id: quickgriditem
    visible: specialItem ? editEnabled : true
    scale: pressed ? 1.2 : 1.0

    onItemUrlChanged: {
        if(!specialItem)
            imgicon.source = mainwindow.settings.icondatabase.provideIcon(itemUrl);
    }

    Behavior on scale {
        NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.OutInBounce }
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
            visible: !specialItem && (itemUrl.length === 0)
            anchors.centerIn: parent
            text: index + 1
            font.pixelSize: Theme.fontSizeLarge
            font.bold: true
            opacity: 0.7
        }

        Image
        {
            id: imgicon
            width: parent.width * 0.4
            height: width
            cache: false
            visible: specialItem ? true : itemUrl.length > 0
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: specialItem ? "image://theme/icon-l-new" : ""
        }

        QuickGridButton
        {
            id: btnedit
            opacity: (!specialItem && editEnabled) ? 1.0 : 0.0
            anchors { left: parent.left; bottom: parent.bottom; leftMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
            icon.source: "image://theme/icon-m-edit"

            onClicked: pageStack.push(Qt.resolvedUrl("../../pages/QuickGridPage.qml"), { "settings": mainwindow.settings, "index": index, "title": lbltitle.text, "url": itemUrl })
        }

        QuickGridButton
        {
            id: btndelete
            opacity: (!specialItem && editEnabled) ? 1.0 : 0.0
            anchors { right: parent.right; bottom: parent.bottom; rightMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
            icon.source: "image://theme/icon-close-vkb"

            onClicked: {
                if(!itemTitle && !itemUrl) /* Do not trigger Remorse Timer if the item is empty */
                {
                    mainwindow.settings.quickgridmodel.remove(index);
                    return;
                }

                tabviewremorse.execute(qsTr("Removing item"),
                                       function() {
                                           mainwindow.settings.quickgridmodel.remove(index);
                                       });
            }
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
