#ifndef DEFAULTBROWSER_H
#define DEFAULTBROWSER_H

#include <QCoreApplication>
#include <QObject>
#include <QDir>
#include <QStandardPaths>
#include <QProcess>

class DefaultBrowser : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    public:
        explicit DefaultBrowser(QObject *parent = 0);
        bool busy() const;
        void setBusy(bool b);
        bool enabled() const;
        void setEnabled(bool b);

    private:
        bool localOpenUrlExists() const;
        bool localServiceExists() const;
        bool isMimeOverriden();
        QDir localDBusDirectory() const;
        QDir localApplicationsDirectory() const;
        void writeLocalOpenUrl() const;
        void writeLocalService() const;
        void deleteLocalOpenUrl() const;
        void deleteLocalService() const;
        void overwriteMime();
        void restoreMime();
        QString executeXdgMime(const QString& args);

    private:
        void setMime(const QString& mimetype, const QString& desktopfile);

    public slots:
        void checkDefaultBrowser();

    signals:
        void busyChanged();
        void enabledChanged();

    private:
        static const QString LOCAL_SERVICE;
        static const QString OPEN_URL;

    private:
        bool _busy;
        bool _enabled;
};

#endif // DEFAULTBROWSER_H
