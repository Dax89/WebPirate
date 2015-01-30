#include "mimedatabase.h"

MimeDatabase::MimeDatabase(QObject *parent): QObject(parent)
{
}

QString MimeDatabase::mimeFromUrl(const QUrl &url)
{
    QRegExp regex(QRegExp("[_\\d\\w\\-\\. ]+\\.[_\\d\\w\\-\\. ]+"));
    QString filename = url.toString().split('/').last();
    int idx = filename.indexOf(regex);

    QMimeType mimetype;

    if(filename.isEmpty() || (idx == -1))
        mimetype = this->_mimedb.mimeTypeForUrl(url);
    else
        mimetype = this->_mimedb.mimeTypeForFile(filename.mid(idx, regex.matchedLength()));

    return mimetype.name();
}
