#ifndef FAVORITESMANAGER_H
#define FAVORITESMANAGER_H

#include <QObject>
#include <QFile>
#include <QUrl>
#include <QRegExp>
#include "favoriteitem.h"

class FavoritesManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(FavoriteItem* root READ root)

    public:
        explicit FavoritesManager(QObject *parent = 0);
        bool parsing() const;
        int foldersFound() const;
        int favoritesFound() const;
        FavoriteItem* root() const;

    private:
        static int nearestPos(int a, int b);
        QString readFile(const QUrl& file);
        void parseFavorite(FavoriteItem *parentfolder, const QString& data, int& currpos);
        void parseFolder(FavoriteItem *parentfolder, const QString &data, const QString& name, int& currpos);

    public slots:
        void importFile(const QUrl &file);
        void clearTree();

    signals:
        void parsingCompleted();

    private:
        FavoriteItem* _root;
        QRegExp _foldernameregex;
        QRegExp _favoriteregex;
        QRegExp _folderbeginregex;
        QRegExp _folderendregex;
};

#endif // FAVORITESMANAGER_H
