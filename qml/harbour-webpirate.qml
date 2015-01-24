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

import QtQuick 2.0
import Sailfish.Silica 1.0
import "models"
import "pages"
import "js/Database.js" as Database
import "js/Favorites.js" as Favorites
import "js/SearchEngines.js" as SearchEngines
import "js/QuickGrid.js" as QuickGrid
import "js/UserAgents.js" as UserAgents
import "js/Credentials.js" as Credentials
import "js/History.js" as History
import "js/Sessions.js" as Sessions
import "js/Cover.js" as Cover

ApplicationWindow
{
    Settings
    {
        id: settings

        Component.onCompleted: {
            Database.load();
            History.load();
            Favorites.load(Database.instance());
            UserAgents.load(Database.instance());
            SearchEngines.load(Database.instance(), settings.searchengines);
            QuickGrid.load(Database.instance(), settings.quickgridmodel, settings.quickgridmodel.maxitems);

            Sessions.createSchema();
            Credentials.createSchema(Database.instance());
            Cover.createSchema(Database.instance());

            var c = Cover.load(Database.instance(), settings.coveractions.generalCategoryId);
            settings.coveractions.generalLeftAction = c.left;
            settings.coveractions.generalRightAction = c.right;

            c = Cover.load(Database.instance(), settings.coveractions.webPageCategoryId);
            settings.coveractions.webPageLeftAction = c.left;
            settings.coveractions.webPageRightAction = c.right;

            var hp = Database.get("homepage");
            settings.homepage = (hp === false ? "about:newtab" : hp);

            var se = Database.get("searchengine");
            settings.searchengine = (se === false ? 0 : se);

            var ua = Database.get("useragent");
            settings.useragent = (ua === false ? 0 : ua);

            settings.clearonexit = parseInt(Database.get("clearonexit"));
        }
    }

    default property alias settings: settings

    id: mainwindow
    allowedOrientations: Orientation.All
    initialPage: Component { MainPage { } }
    cover: null

    Component.onDestruction: {
        if(settings.clearonexit)
        {
            webviewdatabase.clearCache();
            webviewdatabase.clearNavigationData();
            Credentials.clear(Database.instance());
            History.clear();
        }
    }
}
