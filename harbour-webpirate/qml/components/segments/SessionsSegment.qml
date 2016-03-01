import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/items"
import "../../js/settings/Sessions.js" as Sessions

SilicaListView
{
    property int sessionId: -1
    property int currentIndex: 0
    property var session

    function load() {
        Sessions.getAll(sessionmodel);
    }

    function unload() {
        sessionmodel.clear();
    }

    function loadSession(sessionid) {
        Sessions.load(sessionid, tabView);
        pageStack.pop();
    }

    PullDownMenu
    {
        MenuItem {
            text: qsTr("Save current session")

            onClicked: {
                var sessionpage = pageStack.push(Qt.resolvedUrl("../../pages/segment/session/SaveSessionPage.qml"), { "tabView": tabView })

                sessionpage.accepted.connect(function() {
                    Sessions.getAll(sessionmodel);
                });
            }
        }
    }

    id: sessionssegment
    model: ListModel { id: sessionmodel }

    header: PageHeader {
        title: qsTr("Sessions")
    }

    delegate: PageItem {
        id: sessionitem
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall
        itemTitle: name + (Sessions.startupId() === sessionid ? " (" + qsTr("Loads at startup")  + ")" : "")
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
                    var dialog = pageStack.push(Qt.resolvedUrl("../../pages/segment/session/SessionPage.qml"), { "sessionId": sessionid })

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

    ViewPlaceholder
    {
        enabled: sessionssegment.count <= 0
        text: qsTr("No Sessions")
    }
}
