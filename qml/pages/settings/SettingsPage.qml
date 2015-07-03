import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components"

Page
{
    property Settings settings

    id: settingspage
    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            PageHeader
            {
                title: qsTr("Browser Settings")
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                icon: "image://theme/icon-s-setting"
                text: qsTr("General")
                onActionRequested: pageStack.push(Qt.resolvedUrl("GeneralSettingsPage.qml"), { "settings": settingspage.settings })
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                icon: "image://theme/icon-s-group-chat"
                text: qsTr("Tabs")
                onActionRequested: pageStack.push(Qt.resolvedUrl("TabsSettingsPage.qml"), { "settings": settingspage.settings })
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                icon: "qrc:///res/privacy.png"
                text: qsTr("Privacy")
                onActionRequested: pageStack.push(Qt.resolvedUrl("PrivacySettingsPage.qml"), { "settings": settingspage.settings })
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                icon: "qrc:///res/experimental.png"
                text: qsTr("Experimental")
                onActionRequested: pageStack.push(Qt.resolvedUrl("ExperimentalSettingsPage.qml"), { "settings": settingspage.settings })
            }
        }
    }
}
