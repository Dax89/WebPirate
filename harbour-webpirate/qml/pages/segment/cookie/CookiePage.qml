import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../models"

Dialog
{
    property Settings settings
    property var cookieItem
    property string domain

    function validateFields()
    {
        var date = Date.fromLocaleString(Qt.locale(), tfexpires.text, Locale.ShortFormat);

        if(!tfname.text.length || !tfdomain.text.length || !tfpath.text.length || !tfvalue.text.length || isNaN(date))
        {
            dlgcookie.canAccept = false;
            return;
        }

        dlgcookie.canAccept = true;
    }

    function updateCookieData()
    {
        var date = Date.fromLocaleString(Qt.locale(), tfexpires.text, Locale.ShortFormat);

        if(cookieItem)
        {
            cookieItem.name = tfname.text;
            cookieItem.domain = tfdomain.text;
            cookieItem.path = tfpath.text;
            cookieItem.expires = date;
            cookieItem.value = tfvalue.text;

            settings.cookiejar.setCookie(cookieItem);
        }
        else
            settings.cookiejar.setCookie(tfname.text, tfdomain.text, tfpath.text, date, tfvalue.text);
    }

    id: dlgcookie
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: false
    onAccepted: updateCookieData()

    onCookieItemChanged: {
        tfname.text = cookieItem.name;
        tfdomain.text = cookieItem.domain;
        tfpath.text = cookieItem.path;
        tfexpires.text = cookieItem.expires.toLocaleString(null, Locale.ShortFormat);
        tfvalue.text = cookieItem.value;

        tfdomain.enabled = false
        dlgcookie.canAccept = true;
    }

    onDomainChanged: {
        tfdomain.enabled = false;
        tfdomain.text = dlgcookie.domain;
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader
            {
                id: dlgheader
                acceptText: qsTr("Save")
            }

            TextField
            {
                id: tfname
                width: parent.width
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                label: qsTr("Name")
                placeholderText: label
                onTextChanged: validateFields()
            }

            TextField
            {
                id: tfdomain
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                label: qsTr("Domain")
                placeholderText: label
                onTextChanged: validateFields()
            }

            TextField
            {
                id: tfpath
                width: parent.width
                label: qsTr("Path")
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                placeholderText: label
                onTextChanged: validateFields()

                Component.onCompleted: {
                    if(dlgcookie.cookieItem)
                        return;

                    tfpath.text = "/";
                }
            }

            TextField
            {
                id: tfexpires
                width: parent.width
                label: qsTr("Expires")
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                placeholderText: label
                onTextChanged: validateFields()

                Component.onCompleted: {
                    if(dlgcookie.cookieItem)
                        return;

                    var date = new Date(Date.now());
                    tfexpires.text = date.toLocaleString(null, Locale.ShortFormat);
                }
            }

            TextArea
            {
                id: tfvalue
                width: parent.width
                label: qsTr("Value")
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                placeholderText: label
                onTextChanged: validateFields()
            }
        }
    }
}
