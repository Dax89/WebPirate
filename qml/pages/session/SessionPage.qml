import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/tabview"
import "../../components/items"
import "../../js/Sessions.js" as Sessions

Dialog
{
    property int sessionId: -1
    property int currentIndex: 0
    property var session;

    property alias sessionName: tfsessionname.text

    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: tfsessionname.text.length > 0
    onAccepted: Sessions.update(sessionId, tfsessionname.text, tsautoload.checked, tsreplacecurrent.checked)

    Component.onCompleted: {
        if(sessionId === -1)
            return;

        session = Sessions.get(sessionId);

        if(!session)
            return;

        for(var i = 0; i < session.tabs.length; i++)
        {
            if(session.tabs[i].current)
                currentIndex = i;

            sessionmodel.append({ "pagetitle": session.tabs[i].title, "pageurl": session.tabs[i].url, "current": session.tabs[i].current });
        }
    }

    DialogHeader { id: dlgheader; acceptText: qsTr("Save Session") }

    Column
    {
        id: column
        anchors { left: parent.left; top: dlgheader.bottom; right: parent.right }

        TextField
        {
            id: tfsessionname
            width: parent.width
            placeholderText: qsTr("Session name")
            text: session.name
        }

        TextSwitch
        {
            id: tsautoload
            width: parent.width
            text: qsTr("Load at startup")
            checked: session.autoload
        }

        TextSwitch
        {
            id: tsreplacecurrent
            width: parent.width
            text: qsTr("Replace current session")
            checked: session.replacecurrent
        }
    }

    Label
    {
        id: lbltabs

        anchors { left: parent.left; top: column.bottom; right: parent.right;
                  leftMargin: Theme.paddingSmall; topMargin: Theme.paddingLarge; rightMargin: Theme.paddingSmall; }

        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor
        text: qsTr("Opened Tabs") + ":"
        wrapMode: Text.WordWrap
    }

    SilicaListView
    {
        anchors { left: parent.left; top: lbltabs.bottom; right: parent.right; bottom: parent.bottom; topMargin: Theme.paddingSmall }
        model: ListModel { id: sessionmodel }
        clip: true

        delegate: PageItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            itemTitle: pagetitle + (current ? " (" + qsTr("Selected") + ")" : "" )
            itemText: pageurl
        }
    }
}
