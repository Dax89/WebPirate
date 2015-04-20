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

void CookieItem::setName(const QString &name)
{
    if(this->_cookie.name() == name.toUtf8())
        return;

    this->_cookie.setName(name.toUtf8());
    emit nameChanged();
}
