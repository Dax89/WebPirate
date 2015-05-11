#ifndef MIMEDATABASE_H
#define MIMEDATABASE_H

#include <QObject>
#include <QUrl>
#include <QMimeDatabase>
#include <QMimeType>

class MimeDatabase : public QObject
{
    Q_OBJECT

    public:
        explicit MimeDatabase(QObject *parent = 0);

    public slots:
        QString mimeFromUrl(const QUrl& url);

    private:
        QMimeDatabase _mimedb;
};

#endif // MIMEDATABASE_H
