import QtQuick 2.1

Item
{
    Component.onCompleted: {
        if(pageStack.busy)
            pageStack.completeAnimation();

        var page = pageStack.push(Qt.resolvedUrl("../../pages/picker/FilePickerPage.qml"), { "rootPage": mainpage });

        page.filePicked.connect(function(file) {
            model.accept(file);
        });

        page.dismiss.connect(function() {
            model.reject();
        });
    }
}
