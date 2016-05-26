import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/UrlHelper.js" as UrlHelper

JavaScriptDialog // Not really a JS Dialog, but looks similar
{
    property var tab
    property string url

    id: notificationdialog
    title: qsTr("'%1' wants to access system's notifications").arg(UrlHelper.domainName(url))

    Row
    {
        parent: notificationdialog.contentItem
        width: parent.width
        spacing: Theme.paddingSmall

        Button
        {
            id: lblallow
            width: (parent.width / 2) - Theme.paddingSmall
            text: qsTr("Allow")

            onClicked: {
                tab.webView.experimental.postMessage("notificationhandler_granted");
                accept();
            }
        }

        Button
        {
            id: lbldeny
            width: parent.width / 2
            text: qsTr("Deny")

            onClicked: {
                tab.webView.experimental.postMessage("notificationhandler_denied");
                reject();
            }
        }
    }
}

