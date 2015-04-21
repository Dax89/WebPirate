import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate 1.0

Dialog
{
    property alias domain: pageheader.title

    SilicaListView
    {
        header: PageHeader { id: pageheader }

        anchors.fill: parent
    }
}
