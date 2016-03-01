import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../components/tabview"
import "../components/items/cover"
import "../models"
import "../js/settings/Sessions.js" as Sessions

Page
{
    id: mainpage
    allowedOrientations: defaultAllowedOrientations
    showNavigationIndicator: false

    Connections
    {
        target: settings
        onNightmodeChanged: tabview.currentTab().webView.setNightMode(settings.nightmode)
    }

    Connections
    {
        target: settings.webpirateinterface

        onUrlRequested: {
            for(var i = 0; i < args.length; i++)
                tabview.addTab(args[i]);

            mainwindow.activate();
        }
    }

    TabView
    {
        id: tabview
        anchors.fill: parent

        Component.onCompleted: {
            if(Qt.application.arguments.length > 1)  { /* Load requested page */
                tabview.addTab(Qt.application.arguments[1]);
                return;
            }

            var sessionid = Sessions.startupId();

            if(sessionid === -1)
                tabview.addTab(mainwindow.settings.homepage);
            else
                Sessions.load(sessionid, tabview);
        }

        Component.onDestruction: {
            if(settings.restoretabs)
                Sessions.save("__temp__session__", tabview.tabs, tabview.currentIndex, true, true, true);
        }
    }

    PageCoverActions
    {
        id: pagecoveractions
        enabled: (mainpage.status === PageStatus.Active) && (((tabview.currentIndex > -1) && tabview.currentTab()) && tabview.currentTab().viewStack.empty)
    }

    CoverActionList
    {
        enabled: mainpage.status !== PageStatus.Active

        CoverAction
        {
            iconSource: "image://theme/icon-cover-cancel"
            onTriggered: pageStack.pop(mainpage, PageStackAction.Immediate)
        }
    }
}
