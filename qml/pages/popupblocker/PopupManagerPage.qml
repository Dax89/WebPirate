import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/Database.js" as Database
import "../../js/PopupBlocker.js" as PopupBlocker

Page
{
    property PopupModel popupmodel: PopupModel { }

    id: popupmanagerpage
    orientation: Orientation.All
    Component.onCompleted: PopupBlocker.fetchAll(Database.instance(), popupmodel)

    RemorsePopup { id: remorsepopup }

    SilicaListView
    {
        PullDownMenu
        {
            MenuItem {
                text: qsTr("Delete Rules")

                onClicked: {
                    remorsepopup.execute(qsTr("Deleting rules"), function() {
                        PopupBlocker.clearRules(Database.instance());
                        popupmodel.clear();
                    });
                }
            }

            MenuItem {
                text: qsTr("New Rule")

                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewPopupRulePage.qml"));

                    dialog.accepted.connect(function() {
                        var domain = UrlHelper.domainName(dialog.ruleUrl);

                        PopupBlocker.setRule(Database.instance(), UrlHelper.domainName(dialog.ruleUrl), dialog.rule);
                        popupmodel.addRule(domain, dialog.rule);
                    });
                }
            }
        }

        id: listview
        anchors.fill: parent
        header: PageHeader { title: qsTr("Popup Manager") }
        model: popupmodel

        delegate: PopupItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            popupDomain: domain
            popupRule: popuprule

            onBlockPopup: {
                PopupBlocker.setRule(Database.instance(), domain, PopupBlocker.BlockRule);
                popupmodel.setProperty(index, "popuprule", PopupBlocker.BlockRule);
            }

            onAllowPopup: {
                PopupBlocker.setRule(Database.instance(), domain, PopupBlocker.AllowRule);
                popupmodel.setProperty(index, "popuprule", PopupBlocker.AllowRule);
            }

            onDeleteRule: {
                PopupBlocker.setRule(Database.instance(), domain, PopupBlocker.NoRule);
                popupmodel.remove(index);
            }
        }
    }
}
