import QtQuick 2.1

ListModel
{
    id: popupmodel

    function appendPopup(url)
    {
        popupmodel.append({ "url": url });
    }
}
