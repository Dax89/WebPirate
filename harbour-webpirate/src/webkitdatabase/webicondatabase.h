#ifndef WEBICONDATABASE_H
#define WEBICONDATABASE_H

#include <QVariant>
#include <QUrl>
#include "abstractdatabase.h"

class WebIconDatabase: public AbstractDatabase
{
    Q_OBJECT

    public:
        explicit WebIconDatabase(QObject* parent = 0);
        QString queryIconUrl(const QString& url);
        QByteArray queryIconPixmap(const QString& url);

    public slots:
        QString provideIcon(const QString &url);

    protected:
        virtual bool open() const;

    private:
        bool hasIcon(const QString& url);
        int queryIconId(const QString& url);
        QString adjustUrl(const QString& url) const;

    public:
        static const QString PROVIDER_NAME;

    private:
        static const QString CONNECTION_NAME;
        static const QString WEBKIT_DATABASE;
        static const QString ICON_DATABASE;
};

#endif // WEBICONDATABASE_H
