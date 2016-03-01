#include "webviewthumbnailer.h"

#include <QtConcurrent>
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QRegularExpression>
#include <QQuickWindow>
#include <QGuiApplication>
#include <QScreen>

WebViewThumbnailer::WebViewThumbnailer(): _webview(NULL),_thumbnailsdir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/thumbs/")
{
    QDir dir(this->_thumbnailsdir);

    if (!dir.exists())
        dir.mkpath(QStringLiteral("."));
}

QQuickItem *WebViewThumbnailer::webView() const
{
    return this->_webview;
}

QString WebViewThumbnailer::thumbnail() const
{
    return this->_thumbnail;
}

void WebViewThumbnailer::setWebView(QQuickItem *webview)
{
    if(this->_webview == webview)
        return;

    this->_webview = webview;

    QtConcurrent::run(this, &WebViewThumbnailer::processPreview);
    emit webViewChanged();
}

void WebViewThumbnailer::processPreview()
{
    QUrl url = this->_webview->property("url").toUrl();
    QString path = this->thumbnailPath(url);

    if(QFile::exists(path))
    {
        this->_thumbnail = path;
        emit thumbnailChanged();
        return;
    }

    QQuickWindow* window = this->_webview->window();
    QPixmap img = qApp->primaryScreen()->grabWindow(window->winId(), this->_webview->x(), this->_webview->y()); // this->_webview->width(), this->_webview->height());
    img.save(path, "PNG", 9);

    this->_thumbnail = path;
    emit thumbnailChanged();
}

QString WebViewThumbnailer::thumbnailPath(const QUrl &url) const
{
    return this->_thumbnailsdir + this->urlToFileName(url) + ".PNG";
}

QString WebViewThumbnailer::urlToFileName(const QUrl &url) const
{
    return url.host().replace("\\.\\-", "_");
}
