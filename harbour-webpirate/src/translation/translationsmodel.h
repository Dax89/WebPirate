#ifndef TRANSLATIONSMODEL_H
#define TRANSLATIONSMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "translationinfoitem.h"

class TranslationsModel : public QAbstractListModel
{
    Q_OBJECT

    public:
        enum TranslationRoles { ItemRole = Qt::UserRole };

    public:
        explicit TranslationsModel(QObject *parent = 0);
        virtual QVariant data(const QModelIndex &index, int role) const;
        virtual QHash<int, QByteArray> roleNames() const;
        virtual int rowCount(const QModelIndex &) const;

    private:
        QList<TranslationInfoItem*> _items;
};

#endif // TRANSLATIONSMODEL_H
