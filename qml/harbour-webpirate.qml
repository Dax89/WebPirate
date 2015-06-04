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
import Sailfish.Silica 1.0
import "models"
import "pages"
import "js/settings/Database.js" as Database
import "js/settings/Favorites.js" as Favorites
import "js/settings/SearchEngines.js" as SearchEngines
import "js/settings/QuickGrid.js" as QuickGrid
import "js/settings/UserAgents.js" as UserAgents
import "js/settings/PopupBlocker.js" as PopupBlocker
import "js/settings/Credentials.js" as Credentials
import "js/settings/History.js" as History
import "js/settings/Sessions.js" as Sessions
import "js/settings/Cover.js" as Cover

ApplicationWindow
{
    Settings
    {
        id: settings

        downloadmanager.onDownloadCompleted: notifications.send(filename, qsTr("Download Completed"), "icon-m-download", false, true);
        downloadmanager.onDownloadFailed: notifications.send(filename, qsTr("Download Failed"), "icon-m-download", false, true);

        Component.onCompleted: {
            Database.load();
            History.load();
            Sessions.createSchema();
            Favorites.load(Database.instance());

            Database.transaction(function(tx) {
                UserAgents.load(tx);
                PopupBlocker.load(tx);
                SearchEngines.load(tx, settings.searchengines);
                QuickGrid.load(tx, settings.quickgridmodel);

                Credentials.createSchema(tx);
                Cover.createSchema(tx);

                var c = Cover.load(tx, settings.coveractions.generalCategoryId);
                settings.coveractions.generalLeftAction = c.left;
                settings.coveractions.generalRightAction = c.right;

                c = Cover.load(tx, settings.coveractions.webPageCategoryId);
                settings.coveractions.webPageLeftAction = c.left;
                settings.coveractions.webPageRightAction = c.right;

                var hp = Database.transactionGet(tx, "homepage");
                settings.homepage = (hp === false ? "about:newtab" : hp);

                var se = Database.transactionGet(tx, "searchengine");
                settings.searchengine = (se === false ? 0 : se);

                var ua = Database.transactionGet(tx, "useragent");
                settings.useragent = (ua === false ? 0 : ua);

                settings.adblockmanager.enabled = parseInt(Database.transactionGet(tx, "blockads"));
                settings.keepfavicons = parseInt(Database.transactionGet(tx, "keepfavicons"));
                settings.clearonexit = parseInt(Database.transactionGet(tx, "clearonexit"));
                settings.restoretabs = parseInt(Database.transactionGet(tx, "restoretabs"));
            });
        }
    }

    default property alias settings: settings

    id: mainwindow
    allowedOrientations: defaultAllowedOrientations
    initialPage: Component { MainPage { } }
    cover: null

    Component.onDestruction: {
        Database.set("blockads", settings.adblockmanager.enabled ? 1 : 0);

        if(settings.clearonexit) {
            settings.webkitdatabase.clearCache();
            settings.webkitdatabase.clearNavigationData(settings.keepfavicons);
            Credentials.clear(Database.instance());
            History.clear();
        }
    }
}
