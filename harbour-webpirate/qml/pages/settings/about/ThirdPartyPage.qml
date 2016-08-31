import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../components"

Page
{
    id: thirdpartypage
    allowedOrientations: Orientation.Portrait

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        VerticalScrollDecorator { flickable: parent }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader
            {
                id: pageheader
                title: qsTr("Third Party")
            }

            ThirdPartyLabel
            {
                title: "CanVG"
                copyright: qsTr("MIT License")
                licenselink: "https://github.com/gabelerner/canvg/blob/master/MIT-LICENSE.txt"
                link: "https://github.com/gabelerner/canvg"
            }

            ThirdPartyLabel
            {
                title: "ES6 Collections"
                copyright: qsTr("MIT License")
                licenselink: "https://github.com/WebReflection/es6-collections/blob/master/LICENSE.txt"
                link: "https://github.com/WebReflection/es6-collections"
            }

            ThirdPartyLabel
            {
                title: "Readability"
                copyright: qsTr("Apache License")
                licenselink: "https://github.com/mozilla/readability/blob/master/README.md"
                link: "https://github.com/mozilla/readability"
            }
        }
    }
}
