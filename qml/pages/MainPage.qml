/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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

    Connections
    {
        target: Qt.application

        onStateChanged: {
            if(Qt.application.state !== Qt.ApplicationActive)
                tabview.header.evaporate();
            else
                tabview.header.solidify();
        }
    }

    Connections
    {
        target: settings
        onNightmodeChanged: tabview.currentTab().webView.setNightMode(settings.nightmode)
    }

    TabView
    {
        id: tabview
        anchors.fill: parent

        Component.onCompleted: {
            if(Qt.application.arguments.length > 1) /* Load requested page */
            {
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
        enabled: (mainpage.status === PageStatus.Active) && ((tabview.currentIndex > -1) && tabview.currentTab().viewStack.empty)
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
