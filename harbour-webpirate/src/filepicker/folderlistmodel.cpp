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

QString FolderListModel::sdcardFolder() const
{
    QString sdcardfolder;

    if(QFile::exists("/media/sdcard"))
        sdcardfolder = "/media/sdcard";

    if(QFile::exists("/run/user/100000/media/sdcard"))
        sdcardfolder = "/run/user/100000/media/sdcard";

    if(sdcardfolder.isEmpty())
        return QString();

    QDir dir(sdcardfolder);
    QFileInfoList fileinfolist = dir.entryInfoList(QDir::AllDirs | QDir::NoDotAndDotDot | QDir::NoSymLinks, QDir::DirsFirst);

    if(fileinfolist.isEmpty())
        return QString();

    return fileinfolist.first().filePath();
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
        {
            if(fi.isDir())
                return "image://theme/icon-m-folder";

            QMimeType mime = this->_mimedb.mimeTypeForFile(fi.filePath());
            QString type = mime.name().split("/")[0];

            if(type == "video")
                return "image://theme/icon-l-video";

            if(type == "audio")
                return "image://theme/icon-m-sounds";

            if(type == "image")
                return "image://theme/icon-m-image";

            return "image://theme/icon-m-document";
        }

        case FolderListModel::FileNameRole:
            return fi.fileName();

        case FolderListModel::FilePathRole:
            return fi.filePath();

        case FolderListModel::IsFileRole:
            return fi.isFile();

        case FolderListModel::IsFolderRole:
            return fi.isDir();

        case FolderListModel::IsImageRole:
            return fi.isFile() && this->_mimedb.mimeTypeForFile(fi.filePath()).name().split("/")[0] == "image";

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
    roles[FolderListModel::IsImageRole] = "isimage";


    return roles;
}
