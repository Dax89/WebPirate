#include "cookieitem.h"

CookieItem::CookieItem(const QNetworkCookie& cookie, QObject *parent): QObject(parent), _cookie(cookie)
{
}

QString CookieItem::domain() const
{
    return this->_cookie.domain();
}

QString CookieItem::name() const
{
    return this->_cookie.name();
}

QString CookieItem::path() const
{
    return this->_cookie.path();
}

QString CookieItem::expires() const
{
    return this->_cookie.expirationDate().toString(Qt::SystemLocaleShortDate);
}

QString CookieItem::value() const
{
    return this->_cookie.value();
}

void CookieItem::setDomain(const QString &s)
{
    if(this->_cookie.domain() == s.toUtf8())
        return;

    this->_cookie.setDomain(s.toUtf8());
    emit domainChanged();
}

void CookieItem::setName(const QString &s)
{
    if(this->_cookie.name() == s.toUtf8())
        return;

    this->_cookie.setName(s.toUtf8());
    emit nameChanged();
}

void CookieItem::setPath(const QString &s)
{
    if(this->_cookie.path() == s.toUtf8())
        return;

    this->_cookie.setPath(s.toUtf8());
    emit pathChanged();
}

void CookieItem::setExpires(const QString &s)
{
    if(this->_cookie.expirationDate().toString(Qt::SystemLocaleShortDate) == s.toUtf8())
        return;

    this->_cookie.setExpirationDate(QDateTime::fromString(s, Qt::SystemLocaleShortDate));
    emit expiresChanged();
}

void CookieItem::setValue(const QString &s)
{
    if(this->_cookie.value() == s.toUtf8())
        return;

    this->_cookie.setValue(s.toUtf8());
    emit valueChanged();
}
