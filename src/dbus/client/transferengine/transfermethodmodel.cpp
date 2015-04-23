#include "transfermethodmodel.h"

TransferMethodModel::TransferMethodModel(QObject *parent): QAbstractListModel(parent), _transferengine(NULL)
{

}

QString TransferMethodModel::filter() const
{
    return this->_filter;
}

void TransferMethodModel::setFilter(const QString &s)
{
    if(this->_filter == s)
        return;

    this->_filter = s;

    if(this->_transferengine)
        this->updateMethods();

    emit filterChanged();
}

TransferEngine *TransferMethodModel::transferEngine() const
{
    return this->_transferengine;
}

void TransferMethodModel::setTransferEngine(TransferEngine *te)
{
    if(this->_transferengine == te)
        return;

    this->_transferengine = te;

    if(this->_transferengine)
        this->updateMethods();

    emit transferEngineChanged();
}

void TransferMethodModel::updateMethods()
{
    this->_filter.clear();

    if(!this->_filter.isEmpty())
    {
        QList<TransferMethodInfo> methods = this->_transferengine->transferMethods();

        foreach(TransferMethodInfo method, methods)
        {
            if((method.Capabilities.count() == 1) && (method.Capabilities.first() == "*")) // All filters are valid
            {
                this->_methods.append(method);
                continue;
            }

            if(method.Capabilities.indexOf(this->_filter) == -1)
                continue;

            this->_methods.append(method);
        }
    }
    else
        this->_methods = this->_transferengine->transferMethods();


    this->beginInsertRows(QModelIndex(), 0, this->_filter.count() - 1);
    this->endInsertRows();
}

QHash<int, QByteArray> TransferMethodModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TransferMethodModel::MethodId] = "methodId";
    roles[TransferMethodModel::ShareUIPath] = "shareUIPath";

    return roles;
}

int TransferMethodModel::rowCount(const QModelIndex&) const
{
    if(!this->_transferengine)
        return 0;

    return this->_methods.count();
}

QVariant TransferMethodModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || !this->_transferengine || index.row() >= this->_methods.count())
        return QVariant();

    const TransferMethodInfo& tmi = this->_methods.at(index.row());

    switch(role)
    {
        case TransferMethodModel::MethodId:
            return tmi.MethodId;

        case TransferMethodModel::ShareUIPath:
            return tmi.ShareUIpath;

        default:
            break;
    }

    return QVariant();
}
