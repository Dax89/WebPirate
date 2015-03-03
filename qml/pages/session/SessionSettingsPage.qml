import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/tabview"
import "../../components/items"
import "../../js/settings/Sessions.js" as Sessions

Page
{
    property TabView tabView

    function loadSession(sessionid) {
        Sessions.load(sessionid, tabView);
        pageStack.pop();
    }

    PageHeader { id: pageheader; title: qsTr("Session Manager") }

    SilicaListView
    {
        anchors { left: parent.left; top: pageheader.bottom; right: parent.right; bottom: parent.bottom }
        model: ListModel { id: sessionmodel }

        delegate: PageItem {
            id: sessionitem
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            itemTitle: name // + (Sessions.startupId() === sessionid ? " (" + qsTr("Loads at startup")  + ")" : "")
            itemText: qsTr("Tabs saved") + ": " + count

            onClicked: loadSession(sessionid)

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Open")
                    onClicked: loadSession(sessionid)
                }

                MenuItem {
                    text: qsTr("Edit")

                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("SessionPage.qml"), { "sessionId": sessionid })
                        dialog.accepted.connect(function() {
                            sessionmodel.get(index).name = dialog.sessionName;
                        });
                    }
                }

                MenuItem {
                    text: qsTr("Delete")

                    onClicked: sessionitem.remorseAction(qsTr("Deleting session"), function() {
                        Sessions.remove(sessionid);
                        sessionmodel.remove(index);
                    });
                }
            }
        }

        Component.onCompleted: Sessions.getAll(sessionmodel)
    }
}
