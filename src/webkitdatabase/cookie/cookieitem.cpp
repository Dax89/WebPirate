#include "cookieitem.h"

CookieItem::CookieItem(const QString& domain, const QString &name, const QString &value, QObject *parent): QObject(parent), _originaldomain(domain), _originalname(name)
{
    this->_cookie.setDomain(domain);
    this->_cookie.setName(name.toUtf8());
    this->_cookie.setValue(value.toUtf8());
}

CookieItem::CookieItem(const QNetworkCookie& cookie, QObject *parent): QObject(parent), _cookie(cookie), _originaldomain(cookie.domain()), _originalname(cookie.name())
{
}

QString CookieItem::originalDomain() const
{
    return this->_originaldomain;
}

QString CookieItem::originalName() const
{
    return this->_originalname;
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

QDateTime CookieItem::expires() const
{
    return this->_cookie.expirationDate();
}

QString CookieItem::value() const
{
    return this->_cookie.value();
}

void CookieItem::setDomain(const QString &s)
{
    if(this->_cookie.domain() == s)
        return;

    this->_originaldomain = this->_cookie.domain();
    this->_cookie.setDomain(s);
    emit domainChanged();
}

void CookieItem::setName(const QString &s)
{
    if(this->_cookie.name() == s.toUtf8())
        return;

    this->_originalname = this->_cookie.name();
    this->_cookie.setName(s.toUtf8());
    emit nameChanged();
}

void CookieItem::setPath(const QString &s)
{
    if(this->_cookie.path() == s)
        return;

    this->_cookie.setPath(s);
    emit pathChanged();
}

void CookieItem::setExpires(const QDateTime &dt)
{
    this->_cookie.setExpirationDate(dt);
    emit expiresChanged();
}

void CookieItem::setValue(const QString &s)
{
    if(this->_cookie.value() == s.toUtf8())
        return;

    this->_cookie.setValue(s.toUtf8());
    emit valueChanged();
}

QByteArray CookieItem::toRawForm() const
{
    return this->_cookie.toRawForm();
}
