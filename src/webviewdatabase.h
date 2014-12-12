#ifndef WEBVIEWDATABASE_H
#define WEBVIEWDATABASE_H

#include <QObject>
#include <QStandardPaths>
#include <QDir>

class WebViewDatabase : public QObject
{
    Q_OBJECT

    public:
        explicit WebViewDatabase(QObject *parent = 0);

    public slots:
        void clearNavigationData();
};

#endif // WEBVIEWDATABASE_H
