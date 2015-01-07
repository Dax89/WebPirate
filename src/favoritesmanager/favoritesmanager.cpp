#include "favoritesmanager.h"

FavoritesManager::FavoritesManager(QObject *parent): QObject(parent), _root(NULL)
{
    this->_foldernameregex.setPattern("<DT><H3.*>(.+)</H3>");
    this->_foldernameregex.setCaseSensitivity(Qt::CaseInsensitive);
    this->_foldernameregex.setMinimal(true);

    this->_favoriteregex.setPattern("<DT><A HREF=\"([^\"]+)\".*>(.+)</A>");
    this->_favoriteregex.setCaseSensitivity(Qt::CaseInsensitive);
    this->_favoriteregex.setMinimal(true);

    this->_folderbeginregex.setPattern("[\\s]*<DL><p>");
    this->_folderbeginregex.setCaseSensitivity(Qt::CaseInsensitive);
    this->_folderbeginregex.setMinimal(true);

    this->_folderendregex.setPattern("[\\s]*</DL><p>");
    this->_folderendregex.setCaseSensitivity(Qt::CaseInsensitive);
    this->_folderendregex.setMinimal(true);
}

FavoriteItem* FavoritesManager::root() const
{
    return this->_root;
}

int FavoritesManager::nearestPos(int a, int b)
{
    if(a > -1 && b > -1)
        return qMin(a, b);

    if(a > -1)
        return a;

    return b;
}

QString FavoritesManager::readFile(const QUrl &file)
{
    QFile f(file.toLocalFile());
    f.open(QFile::ReadOnly);
    QString data = QString(f.readAll());
    f.close();

    return data;
}

void FavoritesManager::parseFavorite(FavoriteItem* parentfolder, const QString &data, int &currpos)
{
    int pos = data.indexOf(this->_favoriteregex, currpos);

    if(pos == -1)
        return;

    parentfolder->addFavorite(this->_favoriteregex.cap(2).trimmed(), this->_favoriteregex.cap(1).trimmed());
    currpos = pos + this->_favoriteregex.matchedLength();
}

void FavoritesManager::parseFolder(FavoriteItem* parentfolder, const QString& data, const QString& foldername, int &currpos)
{
    int pos = currpos;
    FavoriteItem* folder = NULL;

    if(!this->_root)
    {
        this->_root = new FavoriteItem(QString(), this);
        folder = this->_root;
    }
    else
        folder = parentfolder->addFolder(foldername);

    while(pos != -1)
    {
        int favoritepos = data.indexOf(this->_favoriteregex, pos);
        int foldernamepos = data.indexOf(this->_foldernameregex, pos);
        int folderendpos = data.indexOf(this->_folderendregex, pos);

        currpos = FavoritesManager::nearestPos(favoritepos, FavoritesManager::nearestPos(foldernamepos, folderendpos));

        if(currpos == -1) /* Malformed HTML? */
            return;

        if(currpos == foldernamepos)
        {
            currpos = data.indexOf(this->_folderbeginregex, foldernamepos);
            this->parseFolder(folder, data, this->_foldernameregex.cap(1).trimmed(), currpos);
        }
        else if(currpos == favoritepos)
            this->parseFavorite(folder, data, currpos);
        else if(currpos == folderendpos)
        {
            currpos = folderendpos + this->_folderendregex.matchedLength();
            break;
        }

        pos = currpos;
    }
}

void FavoritesManager::importFile(const QUrl &file)
{
    QString data = this->readFile(file);
    int firstpos = data.indexOf(this->_folderbeginregex);

    if(firstpos == -1)
        return;

    int pos = firstpos + this->_folderbeginregex.matchedLength();
    this->clearTree();
    this->parseFolder(this->_root, data, QString(), pos);

    emit parsingCompleted();
}

void FavoritesManager::clearTree()
{
    if(this->_root)
    {
        this->_root->deleteLater(); /* Free Memory */
        this->_root = NULL;
    }
}
