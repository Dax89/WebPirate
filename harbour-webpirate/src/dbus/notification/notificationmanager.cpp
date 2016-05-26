#include "notificationmanager.h"
#include <QGuiApplication>
#include <QDebug>
#include "notification.h"

const QString NotificationManager::APP_PRETTY_NAME = "WebPirate";

NotificationManager::NotificationManager(QObject *parent): QObject(parent)
{
    this->_appicon = qApp->applicationDirPath() + "/../share/icons/hicolor/86x86/apps/" + qApp->applicationName() + ".png";
}

void NotificationManager::send(const QString &summary, const QString &body, bool feedback, bool temporary)
{
    Notification notification;
    notification.setAppName(NotificationManager::APP_PRETTY_NAME);
    notification.setAppIcon(this->_appicon);
    notification.setPreviewSummary(summary);
    notification.setPreviewBody(body);

    if(feedback)
        notification.setHintValue("x-nemo-feedback", "chat");

    if(!temporary)
    {
        notification.setSummary(summary);
        notification.setBody(body);
    }

    notification.publish();
}

void NotificationManager::send(const QString &summary, const QString &body)
{
    this->send(summary, body, false, false);
}
