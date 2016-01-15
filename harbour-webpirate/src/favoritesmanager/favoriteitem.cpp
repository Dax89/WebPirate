#include "favoriteitem.h"

FavoriteItem::FavoriteItem(QObject* parent): QObject(parent), _isfolder(false)
{

}

FavoriteItem::FavoriteItem(const QString &title, QObject *parent): QObject(parent), _title(title), _isfolder(true)
{

}

FavoriteItem::FavoriteItem(const QString &title, const QString &url, QObject *parent): QObject(parent), _title(title), _url(url), _isfolder(false)
{

}

FavoriteItem *FavoriteItem::addFolder(const QString &title)
{
    FavoriteItem* f = new FavoriteItem(title, this);
    this->_childfavorites.append(f);
    return f;
}

void FavoriteItem::addFavorite(const QString &title, const QString &url)
{
    this->_childfavorites.append(new FavoriteItem(title, url, this));
}

QQmlListProperty<FavoriteItem> FavoriteItem::favorites()
{
    return QQmlListProperty<FavoriteItem>(this, NULL, &FavoriteItem::favoritesCount, &FavoriteItem::favoriteAt);
}

const QList<FavoriteItem *> &FavoriteItem::favoritesList() const
{
    return this->_childfavorites;
}

const QString &FavoriteItem::title() const
{
   return this->_title;
}

const QString &FavoriteItem::url() const
{
    return this->_url;
}

bool FavoriteItem::isFolder() const
{
    return this->_isfolder;
}

int FavoriteItem::favoritesCount(QQmlListProperty<FavoriteItem> *list)
{
    FavoriteItem* fi = qobject_cast<FavoriteItem*>(list->object);

    if(!fi)
        return 0;

    return fi->_childfavorites.count();
}

FavoriteItem *FavoriteItem::favoriteAt(QQmlListProperty<FavoriteItem> *list, int index)
{
    FavoriteItem* fi = qobject_cast<FavoriteItem*>(list->object);

    if(!fi)
        return NULL;

    return fi->_childfavorites.at(index);
}
