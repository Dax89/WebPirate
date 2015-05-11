import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../js/settings/SearchEngines.js" as SearchEngines
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/settings/Database.js" as Database

Dialog
{
    property Settings settings
    property int index: -1
    property string name
    property string query

    id: dlgsearchengine
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    Column
    {
        anchors.fill: parent

        DialogHeader {
            title: qsTr("Save")
        }

        TextField
        {
            id: tfname
            label: qsTr("Name")
            placeholderText: qsTr("Name")
            text: name
            width: parent.width
        }

        TextField
        {
            id: tfquery
            label: qsTr("Query")
            placeholderText: qsTr("Query")
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase
            text: query
        }
    }

    onDone: {
        if(result === DialogResult.Accepted)
        {
            if(!UrlHelper.isUrl(tfquery.text))
                return;

            if(index == -1)
                SearchEngines.add(Database.instance(), settings.searchengines, tfname.text, UrlHelper.adjustUrl(tfquery.text));
            else
                SearchEngines.replace(Database.instance(), settings.searchengines, dlgsearchengine.index, tfname.text, UrlHelper.adjustUrl(tfquery.text));
        }
    }
}
