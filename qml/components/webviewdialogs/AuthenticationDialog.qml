import QtQuick 2.1
import Sailfish.Silica 1.0

Dialog
{
    property var authenticationModel

    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true
    onAccepted: authenticationModel.accept(tfuser.text, tfpassword.text)
    onRejected: authenticationModel.reject()

    Component.onCompleted: {
        lbldescription.text = authenticationModel.hostname + " " + qsTr("requires authentication");
        tfuser.text = authenticationModel.prefilledUsername;
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            DialogHeader { acceptText: qsTr("Login") }

            Label
            {
                id: lbltitle
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Theme.highlightColor
                text: qsTr("Authentication required")
            }

            Label
            {
                id: lbldescription
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            TextField
            {
                id: tfuser
                width: parent.width
                placeholderText: qsTr("User")
            }

            TextField
            {
                id: tfpassword
                width: parent.width
                placeholderText: qsTr("Password")
            }
        }
    }
}
