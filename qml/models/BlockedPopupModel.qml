import QtQuick 2.1

ListModel
{
    id: blockedpopupmodel

    function appendPopup(url)
    {
        blockedpopupmodel.append({ "url": url });
    }
}
