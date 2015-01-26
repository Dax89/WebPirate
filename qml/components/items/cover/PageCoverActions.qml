import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../models/cover"

CoverActionList
{
    id: pagecoveractions

    function getCategoryId()
    {
        return tabview.pageState === "webbrowser" ? mainwindow.settings.coveractions.webPageCategoryId : mainwindow.settings.coveractions.generalCategoryId;
    }

    iconBackground: true

    CoverAction
    {
        id: leftaction

        iconSource: {
            var categoryid = getCategoryId();
            mainwindow.settings.coveractions.leftActionIcon(categoryid);
        }

        onTriggered: {
            var categoryid = getCategoryId();
            mainwindow.settings.coveractions.executeLeftAction(tabview, categoryid);
        }
    }

    CoverAction
    {
        id: rightaction

        iconSource: {
            var categoryid = getCategoryId();
            mainwindow.settings.coveractions.rightActionIcon(categoryid);
        }

        onTriggered: {
            var categoryid = getCategoryId();
            mainwindow.settings.coveractions.executeRightAction(tabview, categoryid);
        }
    }
}
