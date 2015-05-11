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

#include <QtQuick>
#include <sailfishapp.h>
#include "dbus/client/machineid.h"
#include "dbus/client/screenblank.h"
#include "dbus/client/urlcomposer.h"
#include "dbus/client/ofono/ofono.h"
#include "dbus/client/transferengine/transferengine.h"
#include "dbus/client/transferengine/transfermethodmodel.h"
#include "security/cryptography/aes256.h"
#include "network/networkinterfaces.h"
#include "favoritesmanager/favoritesmanager.h"
#include "downloadmanager/downloadmanager.h"
#include "filepicker/folderlistmodel.h"
#include "adblock/adblockeditor.h"
#include "adblock/adblockmanager.h"
#include "adblock/adblockdownloader.h"
#include "mime/mimedatabase.h"
#include "webkitdatabase/cookie/cookiejar.h"
#include "webkitdatabase/webkitdatabase.h"
#include "imageproviders/faviconprovider.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    application->setApplicationName("harbour-webpirate");

    qmlRegisterType<AbstractDownloadItem>("harbour.webpirate.Private", 1, 0, "DownloadItem");
    qmlRegisterType<FavoriteItem>("harbour.webpirate.Private", 1, 0, "FavoriteItem");
    qmlRegisterType<MimeDatabase>("harbour.webpirate.Private", 1, 0, "MimeDatabase");

    qmlRegisterSingletonType<AES256>("harbour.webpirate.Security", 1, 0, "AES256", &AES256::initialize);
    qmlRegisterSingletonType<NetworkInterfaces>("harbour.webpirate.Network", 1, 0, "NetworkInterfaces", &NetworkInterfaces::initialize);
    qmlRegisterSingletonType<MachineID>("harbour.webpirate.DBus", 1, 0, "MachineID", &MachineID::initialize);
    qmlRegisterSingletonType<Ofono>("harbour.webpirate.DBus", 1, 0, "Ofono", &Ofono::initialize);

    qmlRegisterType<ScreenBlank>("harbour.webpirate.DBus", 1, 0, "ScreenBlank");
    qmlRegisterType<UrlComposer>("harbour.webpirate.DBus", 1, 0, "UrlComposer");
    qmlRegisterType<TransferEngine>("harbour.webpirate.DBus.TransferEngine", 1, 0, "TransferEngine");
    qmlRegisterType<TransferMethodModel>("harbour.webpirate.DBus.TransferEngine", 1, 0, "TransferMethodModel");

    qmlRegisterType<FolderListModel>("harbour.webpirate.Pickers", 1, 0, "FolderListModel");

    qmlRegisterType<AdBlockEditor>("harbour.webpirate.AdBlock", 1, 0, "AdBlockEditor");
    qmlRegisterType<AdBlockDownloader>("harbour.webpirate.AdBlock", 1, 0, "AdBlockDownloader");
    qmlRegisterType<AdBlockManager>("harbour.webpirate.AdBlock", 1, 0, "AdBlockManager");

    qmlRegisterType<CookieJar>("harbour.webpirate.WebKit", 1, 0, "CookieJar");
    qmlRegisterType<WebKitDatabase>("harbour.webpirate.WebKit", 1, 0, "WebKitDatabase");
    qmlRegisterType<WebIconDatabase>("harbour.webpirate.WebKit", 1, 0, "WebIconDatabase");
    qmlRegisterType<DownloadManager>("harbour.webpirate.WebKit", 1, 0, "DownloadManager");

    qmlRegisterType<FavoritesManager>("harbour.webpirate.LocalStorage", 1, 0, "FavoritesManager");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine* engine = view->engine();
    QObject::connect(engine, SIGNAL(quit()), application.data(), SLOT(quit()));

    engine->addImageProvider(WebIconDatabase::PROVIDER_NAME, new FaviconProvider());
    view->setSource(SailfishApp::pathTo("qml/harbour-webpirate.qml"));
    view->show();

    return application->exec();
}
