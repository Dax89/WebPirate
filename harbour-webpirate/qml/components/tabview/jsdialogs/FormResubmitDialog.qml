import QtQuick 2.1
import Sailfish.Silica 1.0

JavaScriptDialog // Not really a JS Dialog, but looks similar
{
    property var tab
    property string url

    function clearData() {
        tab = null;
        url = "";
    }

    id: formresubmitdialog
    title: qsTr("This page contains information written by you: do you want to resend the data?")

    Row
    {
        parent: formresubmitdialog.contentItem
        width: parent.width
        spacing: Theme.paddingSmall

        Button
        {
            id: lblyes
            width: (parent.width / 2) - Theme.paddingSmall
            text: qsTr("Yes")

            onClicked: {
                tab.load(formresubmitdialog.url);
                accept();
                clearData();
            }
        }

        Button
        {
            id: lblno
            width: parent.width / 2
            text: qsTr("No")

            onClicked: {
                reject();
                clearData();
            }
        }
    }
}
