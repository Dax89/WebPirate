#ifndef DEFAULTBROWSER_H
#define DEFAULTBROWSER_H

#include <QObject>
#include <QDir>
#include <QStandardPaths>

class DefaultBrowser : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    public:
        explicit DefaultBrowser(QObject *parent = 0);
        bool enabled() const;
        void setEnabled(bool b);

    private:
        bool localServiceExists() const;
        bool localOpenUrlExists() const;
        QDir localDBusDirectory() const;
        QDir localApplicationsDirectory() const;
        void writeLocalService() const;
        void writeLocalOpenUrl() const;
        void deleteLocalService() const;
        void deleteLocalOpenUrl() const;

    signals:
        void enabledChanged();

    private:
        static const QString LOCAL_SERVICE;
        static const QString OPEN_URL;

    private:
        bool _enabled;
};

#endif // DEFAULTBROWSER_H
