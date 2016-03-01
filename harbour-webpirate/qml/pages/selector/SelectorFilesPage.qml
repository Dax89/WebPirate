import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.Selectors 1.0
import "../../models"

Dialog
{
    property int filter: FilesModel.NoFilter
    property var selectedFiles: []
    readonly property string rootPathLimit : "/"

    signal actionCompleted(string action, var data)

    id: selectorfilespage
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: selectedFiles.length > 0
    onAccepted: selectedFiles.forEach(function (element) { actionCompleted("file", element); })

    FilesModel
    {
        id: filesmodel
        folder: "HomeFolder"
        directoriesFirst: true
        sortOrder: Qt.AscendingOrder
        sortRole: FilesModel.NameRole
        filter: selectorfilespage.filter
    }

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Android storage")
                visible: filesmodel.androidStorage.length > 0

                onClicked: {
                    filesmodel.folder = filesmodel.androidStorage;
                }
            }

            MenuItem {
                text: qsTr("SD Card")
                visible: filesmodel.sdcardFolder.length > 0

                onClicked: {
                    filesmodel.folder = filesmodel.sdcardFolder;
                }
            }

            MenuItem {
                text: qsTr("Home")

                onClicked: {
                    filesmodel.folder = filesmodel.homeFolder;
                }
            }
        }

        DialogHeader
        {
            id: header
            acceptText: qsTr("Send %1 file(s)").arg(selectedFiles.length)
            title: filesmodel.folder
        }

        Button
        {
            id: btnparent
            text: qsTr("Back")
            visible: (filesmodel.folder !== rootPathLimit)
            anchors { left: parent.left; top: header.bottom; right: parent.right; margins: Theme.paddingMedium }

            onClicked: {
                filesmodel.folder = filesmodel.parentFolder;
            }
        }

        SilicaListView
        {
            id: lvfiles
            clip: true
            quickScroll: true
            model: filesmodel
            anchors { top: btnparent.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

            delegate: ListItem {
                property bool isSelected: (selectedFiles.indexOf(model.url) > -1)

                contentHeight: Theme.itemSizeSmall
                anchors { left: parent.left; right: parent.right }
                highlighted: isSelected

                onClicked: {
                    if (model.isDir)
                        filesmodel.folder = model.path;
                    else
                        //selectedFiles needs to be reassigned every time it is manipulated because it doesn't emit signals otherwise
                        if (isSelected) {
                            selectedFiles = selectedFiles.filter(function (element) { return element !== model.url; });
                        } else {
                            selectedFiles = selectedFiles.concat([model.url]);
                        }
                }

                Image {
                    id: imgfilefolder
                    source: model.icon
                    anchors { left: parent.left; margins: Theme.paddingMedium; verticalCenter: parent.verticalCenter }
                }

                Label {
                    text: (model.name || "")
                    elide: Text.ElideMiddle
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 2
                    font.family: Theme.fontFamilyHeading
                    font.bold: isSelected
                    color: isSelected ? Theme.highlightColor : Theme.primaryColor
                    anchors { left: imgfilefolder.right; right: parent.right; margins: Theme.paddingMedium; verticalCenter: parent.verticalCenter }
                }
            }
        }
    }
}
