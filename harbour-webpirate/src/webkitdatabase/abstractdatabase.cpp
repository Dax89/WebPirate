#include "abstractdatabase.h"

QHash<QString, int> AbstractDatabase::_connections;

AbstractDatabase::AbstractDatabase(const QString& connectionname, QObject *parent): QObject(parent), _connectionname(connectionname)
{
    if(!AbstractDatabase::_connections.contains(connectionname))
    {
        AbstractDatabase::_connections[connectionname] = 1;
        QSqlDatabase::addDatabase("QSQLITE", connectionname);
    }
    else
        AbstractDatabase::_connections[connectionname]++;
}

AbstractDatabase::~AbstractDatabase()
{
    AbstractDatabase::_connections[this->_connectionname]--;

    if(!AbstractDatabase::_connections[this->_connectionname])
    {
        QSqlDatabase db = QSqlDatabase::database(this->_connectionname, false);

        if(db.isOpen())
            db.close();

        db = QSqlDatabase(); // Reset Database Reference
        QSqlDatabase::removeDatabase(this->_connectionname);
        AbstractDatabase::_connections.remove(this->_connectionname);
    }
}

const QString &AbstractDatabase::connectionName() const
{
    return this->_connectionname;
}

bool AbstractDatabase::prepare(QSqlQuery &queryobj, const QString &query)
{
    if(!queryobj.prepare(query))
    {
        qWarning() << Q_FUNC_INFO << "failed to prepare query";
        qWarning() << queryobj.lastError();
        qWarning() << queryobj.lastQuery();

        return false;
    }

    return true;
}

bool AbstractDatabase::execute(QSqlQuery &queryobj)
{
    if(!queryobj.exec())
    {
        qWarning() << Q_FUNC_INFO << "failed to execute query";
        qWarning() << queryobj.lastError();
        qWarning() << queryobj.lastQuery();

        return false;
    }

    return true;
}
