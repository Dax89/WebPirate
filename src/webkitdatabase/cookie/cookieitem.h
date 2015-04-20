#ifndef COOKIEITEM_H
#define COOKIEITEM_H

#include <QObject>
#include <QNetworkCookie>

class CookieItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString domain READ domain CONSTANT FINAL)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

    public:
        explicit CookieItem(const QNetworkCookie& cookie, QObject *parent = 0);

    public:
        QString domain() const;
        QString name() const;

    public:
        void setName(const QString& name);

    signals:
        void nameChanged();

    private:
        QNetworkCookie _cookie;
};

Q_DECLARE_METATYPE(CookieItem*)

#endif // COOKIEITEM_H
