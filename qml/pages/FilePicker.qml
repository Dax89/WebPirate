import QtQuick 2.1
import Sailfish.Pickers 1.0

ContentPickerPage
{
    signal fileSelected(string file)

    id: filepicker

    Component.onDestruction: {
        var selectedfile = selectedContent.toString();

        if(selectedfile.length > 0)
            fileSelected(selectedContent);
    }
}
