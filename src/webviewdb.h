#ifndef WEBVIEWDB_H
#define WEBVIEWDB_H

#include <QObject>
#include <QStandardPaths>
#include <QDir>

class WebViewDB : public QObject
{
    Q_OBJECT

    public:
        explicit WebViewDB(QObject *parent = 0);

    public slots:
        void clearNavigationData();
};

#endif // WEBVIEWDB_H
