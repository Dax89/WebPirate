#ifndef WEBICONDATABASE_H
#define WEBICONDATABASE_H

#include <QObject>
#include <QDir>
#include <QVariant>
#include <QStandardPaths>
#include <QQuickImageProvider>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class WebIconDatabase : public QQuickImageProvider
{
    public:
        explicit WebIconDatabase();
        QImage requestImage(const QString& id, QSize* size, const QSize&);
        ~WebIconDatabase();

    private:
        bool open();
        int queryIconId(const QString& url);
        QByteArray queryIconPixmap(const QString& url);

    private:
        bool prepare(QSqlQuery &queryobj, const QString& query);
        bool execute(QSqlQuery &queryobj);

    private:
        QSqlDatabase _db;

    public:
        static const QString FAVICON_PROVIDER;

    private:
        static const QString WEBKIT_DATABASE;
        static const QString ICON_DATABASE;
};

#endif // WEBICONDATABASE_H
