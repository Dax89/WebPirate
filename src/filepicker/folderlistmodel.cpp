#include "folderlistmodel.h"

FolderListModel::FolderListModel(QObject *parent): QAbstractListModel(parent)
{
}

QString FolderListModel::directoryName() const
{
    return this->_directory.dirName();
}

QString FolderListModel::directory() const
{
    return this->_directory.path();
}

void FolderListModel::setDirectory(const QString &path)
{
    if(this->_directory.path() == path)
        return;

    this->_directory = QDir(path);

    emit directoryChanged();
    emit directoryNameChanged();

    if(!this->_directory.path().isEmpty())
        this->readDirectory();
}

const QString& FolderListModel::filter() const
{
    return this->_filter;
}

void FolderListModel::setFilter(const QString& f)
{
    if(this->_filter == f)
        return;

    this->_filter = f;
    emit filterChanged();

    if(!this->_directory.path().isEmpty())
        this->readDirectory();
}

QString FolderListModel::homeFolder() const
{
    return QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
}

void FolderListModel::readDirectory()
{
    this->beginResetModel();

    if(!this->_filter.isEmpty())
        this->_directory.setNameFilters(this->_filter.split(";"));
    else
        this->_directory.setNameFilters(QStringList());

    this->_files = this->_directory.entryInfoList(QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks, QDir::DirsFirst);
    this->endResetModel();
}

int FolderListModel::rowCount(const QModelIndex&) const
{
    return this->_files.length();
}

QVariant FolderListModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || index.row() >= this->_files.length())
        return QVariant();

    const QFileInfo& fi = this->_files.at(index.row());

    switch(role)
    {
        case FolderListModel::FileIconRole:
            return (fi.isFile() ? "image://theme/icon-m-document" : "image://theme/icon-m-folder");

        case FolderListModel::FileNameRole:
            return fi.fileName();

        case FolderListModel::FilePathRole:
            return fi.filePath();

        case FolderListModel::IsFileRole:
            return fi.isFile();

        case FolderListModel::IsFolderRole:
            return fi.isDir();

        default:
            break;
    }

    return QVariant();
}

QHash<int, QByteArray> FolderListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FolderListModel::FileIconRole] = "fileicon";
    roles[FolderListModel::FileNameRole] = "filename";
    roles[FolderListModel::FilePathRole] = "filepath";
    roles[FolderListModel::IsFileRole] = "isfile";
    roles[FolderListModel::IsFolderRole] = "isfolder";

    return roles;
}
