import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items/cover"

Page
{
    property Settings settings
    property list<QtObject> coversettingsmodel: [ QtObject { readonly property string actionName: qsTr("General Actions")
                                                             readonly property int categoryId: settings.coveractions.generalCategoryId },

                                                  QtObject { readonly property string actionName: qsTr("Webpage Actions")
                                                             readonly property int categoryId: settings.coveractions.webPageCategoryId } ]

    id: coversettingspage
    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            PageHeader { id: pageheader; title: qsTr("Cover Settings") }

            Repeater
            {
                model: coversettingsmodel

                delegate: Item {
                    width: parent.width
                    height: secthdr.height + leftcbx.height + rightcbx.height

                    SectionHeader { id: secthdr; text: actionName }

                    ComboBox {
                        id: leftcbx
                        anchors { left: parent.left; top: secthdr.bottom; right: parent.right }
                        label: qsTr("Left") + ":"
                        onCurrentIndexChanged: settings.coveractions.setLeftAction(categoryId, leftcbx.currentIndex)

                        menu: CoverMenu {
                            menuCategory: categoryId
                            menuPosition: "left"

                            Component.onCompleted: {
                                leftcbx.currentIndex = settings.coveractions.selectedLeftAction(categoryId);
                            }
                        }
                    }

                    ComboBox {
                        id: rightcbx
                        anchors { left: parent.left; top: leftcbx.bottom; right: parent.right }
                        label: qsTr("Right") + ":"
                        onCurrentIndexChanged: settings.coveractions.setRightAction(categoryId, rightcbx.currentIndex)

                        menu: CoverMenu {
                            menuCategory: categoryId
                            menuPosition: "right"

                            Component.onCompleted: {
                                rightcbx.currentIndex = settings.coveractions.selectedRightAction(categoryId);
                            }
                        }
                    }
                }
            }
        }
    }
}
