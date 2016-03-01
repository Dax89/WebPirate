#ifndef WEBVIEWTHUMBNAILER_H
#define WEBVIEWTHUMBNAILER_H

#include <QObject>
#include <QQuickItem>
#include <QUrl>

class WebViewThumbnailer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickItem* webView READ webView WRITE setWebView NOTIFY webViewChanged)
    Q_PROPERTY(QString thumbnail READ thumbnail NOTIFY thumbnailChanged)

    public:
        WebViewThumbnailer();
        QQuickItem* webView() const;
        QString thumbnail() const;
        void setWebView(QQuickItem* webview);

    private slots:
        void processPreview();
        QString thumbnailPath(const QUrl& url) const;
        QString urlToFileName(const QUrl& url) const;

    private:
        QQuickItem* _webview;
        QString _thumbnail;

    signals:
        void webViewChanged();
        void thumbnailChanged();

    private:
        const QString _thumbnailsdir;
};

#endif // WEBVIEWTHUMBNAILER_H
