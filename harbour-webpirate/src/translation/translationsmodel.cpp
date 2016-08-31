#include "translationsmodel.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>

TranslationsModel::TranslationsModel(QObject *parent) : QAbstractListModel(parent)
{
    QFile jsonfile(":/translations/translations.json");

    if(!jsonfile.open(QFile::ReadOnly))
        return;

    QJsonParseError error;
    QJsonDocument json = QJsonDocument::fromJson(jsonfile.readAll(), &error);

    if(error.error != QJsonParseError::NoError)
        return;

    foreach (QJsonValue jsonarrayvalue, json.array())
        this->_items.append(new TranslationInfoItem(jsonarrayvalue.toObject(), this));
}

QVariant TranslationsModel::data(const QModelIndex &index, int role) const
{
    if(role != TranslationsModel::ItemRole)
        return QVariant();

    return QVariant::fromValue<TranslationInfoItem*>(this->_items.at(index.row()));
}

QHash<int, QByteArray> TranslationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[TranslationsModel::ItemRole] = "item";
    return roles;
}

int TranslationsModel::rowCount(const QModelIndex &) const
{
    return this->_items.count();
}

