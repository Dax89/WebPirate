#ifndef ABSTRACTDATABASE_H
#define ABSTRACTDATABASE_H

#include <QObject>
#include <QHash>
#include <QDir>
#include <QStandardPaths>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

class AbstractDatabase : public QObject
{
    Q_OBJECT

    protected:
        explicit AbstractDatabase(const QString& connectionname, QObject *parent = 0);

    public:
        ~AbstractDatabase();
        const QString& connectionName() const;

    protected:
        virtual bool open() const = 0;
        bool prepare(QSqlQuery &queryobj, const QString& query);
        bool execute(QSqlQuery &queryobj);

    private:
        static QHash<QString, int> _connections;
        QString _connectionname;
};

#endif // ABSTRACTDATABASE_H
