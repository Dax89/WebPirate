#ifndef COOKIEITEM_H
#define COOKIEITEM_H

#include <QObject>
#include <QNetworkCookie>
#include <QDateTime>

class CookieItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString domain READ domain WRITE setDomain NOTIFY domainChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString expires READ expires WRITE setExpires NOTIFY expiresChanged)
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)

    public:
        explicit CookieItem(const QNetworkCookie& cookie, QObject *parent = 0);

    public:
        QString domain() const;
        QString name() const;
        QString path() const;
        QString expires() const;
        QString value() const;

    public:
        void setDomain(const QString& s);
        void setName(const QString& s);
        void setPath(const QString& s);
        void setExpires(const QString& s);
        void setValue(const QString& s);

    signals:
        void domainChanged();
        void nameChanged();
        void pathChanged();
        void expiresChanged();
        void valueChanged();

    private:
        QNetworkCookie _cookie;
};

Q_DECLARE_METATYPE(CookieItem*)

#endif // COOKIEITEM_H
