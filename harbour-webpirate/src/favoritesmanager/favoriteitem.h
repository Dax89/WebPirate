#ifndef FAVORITEITEM_H
#define FAVORITEITEM_H

#include <QObject>
#include <QList>
#include <QQmlListProperty>

class FavoriteItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<FavoriteItem> favorites READ favorites)
    Q_PROPERTY(QString title READ title)
    Q_PROPERTY(QString url READ url)
    Q_PROPERTY(bool isFolder READ isFolder)

    public:
        explicit FavoriteItem(QObject *parent = 0);
        explicit FavoriteItem(const QString& title, QObject *parent = 0);
        explicit FavoriteItem(const QString& title, const QString& url, QObject *parent = 0);
        QQmlListProperty<FavoriteItem> favorites();
        const QList<FavoriteItem*>& favoritesList() const;
        const QString& title() const;
        const QString& url() const;
        bool isFolder() const;

    public slots:
        FavoriteItem* addFolder(const QString& title);
        void addFavorite(const QString& title, const QString& url);

    private:
        static int favoritesCount(QQmlListProperty<FavoriteItem> *list);
        static FavoriteItem* favoriteAt(QQmlListProperty<FavoriteItem>* list, int index);

    private:
        QList<FavoriteItem*> _childfavorites;
        QString _title;
        QString _url;
        bool _isfolder;
};

#endif // FAVORITEITEM_H
