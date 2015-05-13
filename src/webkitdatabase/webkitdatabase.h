#ifndef WEBVIEWDATABASE_H
#define WEBVIEWDATABASE_H

#include <QCoreApplication>
#include <QObject>
#include <QStandardPaths>
#include <QDir>

class WebKitDatabase : public QObject
{
    Q_OBJECT

    public:
        explicit WebKitDatabase(QObject *parent = 0);

    private:
        void renameDatabase();

    public slots:
        void clearNavigationData(bool keepfavicons);
        void clearCache();

    private:
        static const QString OLD_DB_NAME;
        static const QString WEBKIT_DATABASE;
};

#endif // WEBVIEWDATABASE_H
