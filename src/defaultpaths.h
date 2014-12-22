#ifndef DEFAULTPATHS_H
#define DEFAULTPATHS_H

#include <QObject>
#include <QDir>
#include <QStandardPaths>

class DefaultPaths : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString homeDirectory READ homeDirectory)
    Q_PROPERTY(QString downloadDirectory READ downloadDirectory)

    public:
        explicit DefaultPaths(QObject *parent = 0);
        QString homeDirectory() const;
        QString downloadDirectory() const;
};

#endif // DEFAULTPATHS_H
