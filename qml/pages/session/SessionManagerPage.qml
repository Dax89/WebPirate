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

    id: sessionmanagerpage
    allowedOrientations: defaultAllowedOrientations

    SilicaListView
    {
        anchors.fill: parent
        model: ListModel { id: sessionmodel }

        PullDownMenu
        {
            MenuItem {
                text: qsTr("Save current session")

                onClicked: {
                    var sessionpage = pageStack.push(Qt.resolvedUrl("SaveSessionPage.qml"), { "tabView": tabView })

                    sessionpage.accepted.connect(function() {
                        Sessions.getAll(sessionmodel);
                    });
                }
            }
        }

        header: PageHeader {
            id: pageheader;
            title: qsTr("Session Manager")
        }

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
