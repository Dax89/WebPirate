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

FavoriteItem* FavoritesManager::root()
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

QString FavoritesManager::locateSailfishBrowserFavorites()
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));

    if(!dir.cd("org.sailfishos"))
        return QString();

    if(!dir.cd("sailfish-browser"))
        return QString();

    QString bookmarkspath = dir.absoluteFilePath("bookmarks.json");

    if(!QFile::exists(bookmarkspath))
        return QString();

    return bookmarkspath;
}

QString FavoritesManager::readFile(const QString &file)
{
    QString s(file);

    QFile f(s.replace("file://", ""));
    f.open(QFile::ReadOnly);
    QString data = QString(f.readAll());
    f.close();

    return data;
}

void FavoritesManager::writeHeader(QTextStream& ts)
{
    ts << "<!DOCTYPE NETSCAPE-Bookmark-file-1>" << endl;
    ts << "<!-- This is an automatically generated file." << endl;
    ts << "    It will be read and overwritten." << endl;
    ts << "    DO NOT EDIT! -->" << endl;
    ts << "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">" << endl;
    ts << "<TITLE>Bookmarks</TITLE>" << endl;
    ts << "<H1>Bookmarks</H1>" << endl;
}

void FavoritesManager::exportBookmarks(FavoriteItem* parentitem, QTextStream &ts, int level)
{
    QString indent = QString(" ").repeated(level * 4);
    const QList<FavoriteItem*>& favorites = parentitem->favoritesList();

    foreach(FavoriteItem* favorite, favorites)
    {
        if(favorite->isFolder())
        {
            ts << indent << "<DT><H3>" << favorite->title() << "</H3>" << endl;
            ts << indent << "<DL><p>" << endl;

            this->exportBookmarks(favorite, ts, level + 1);

            ts << indent << "</DL><p>" << endl;
        }
        else
            ts << indent << "<DT><A HREF=\"" << favorite->url() << "\">" << favorite->title() << "</A>" << endl;
    }
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

void FavoritesManager::importFromSailfishBrowser()
{
    QString s = this->locateSailfishBrowserFavorites();

    if(s.isEmpty())
    {
        emit parsingError();
        return;
    }

    QJsonDocument jsondoc = QJsonDocument::fromJson(this->readFile(s).toUtf8());
    this->clearTree();

    this->_root = new FavoriteItem(QString(), this);

    if(!jsondoc.isArray())
    {
        this->clearTree();
        emit parsingError();
        return;
    }

    QJsonArray jsonarray = jsondoc.array();

    for(int i = 0; i < jsonarray.count(); i++)
    {
        QJsonObject jsonobject = jsonarray.at(i).toObject();
        this->_root->addFavorite(jsonobject["title"].toString(), jsonobject["url"].toString());
    }

    emit parsingCompleted();
}

void FavoritesManager::importFile(const QString &file)
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

void FavoritesManager::createRoot()
{
    this->_root = new FavoriteItem(QString(), this);
}

void FavoritesManager::exportFile(const QString &foldername)
{
    QString documentspath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QFile f(QString("%1%2%3_%4.html").arg(documentspath, QDir::separator(), foldername, QDateTime::currentDateTime().toString("dd_MM_yy__HH_mm_ss")));
    f.open(QFile::WriteOnly | QFile::Truncate);

    QTextStream ts(&f);
    ts.setCodec("UTF-8");

    this->writeHeader(ts);

    ts << "<DL><p>" << endl;
    this->exportBookmarks(this->_root, ts, 1);
    ts << "</DL><p>" << endl;

    f.close();
}

void FavoritesManager::clearTree()
{
    if(this->_root)
    {
        this->_root->deleteLater(); /* Free Memory */
        this->_root = NULL;
    }
}
