#ifndef WEBICONDATABASE_H
#define WEBICONDATABASE_H

#include <QObject>
#include <QDir>
#include <QVariant>
#include <QUrl>
#include <QStandardPaths>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class WebIconDatabase : public QObject
{
    Q_OBJECT

    public:
        explicit WebIconDatabase(QObject* parent = 0);
        QString queryIconUrl(const QString& url);
        QByteArray queryIconPixmap(const QString& url);
        ~WebIconDatabase();

    public slots:
        QString provideIcon(const QString &url);

    private:
        bool open();
        bool prepare(QSqlQuery &queryobj, const QString& query);
        bool execute(QSqlQuery &queryobj);
        bool hasIcon(const QString& url);
        int queryIconId(const QString& url);
        QString adjustUrl(const QString& url) const;

    private:
        static int _refcount;

    public:
        static const QString PROVIDER_NAME;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString ICON_DATABASE;
};

#endif // WEBICONDATABASE_H
