#include "webpagedownloaditem.h"

const QString WebPageDownloadItem::DEFAULT_FILENAME = "download.html";

WebPageDownloadItem::WebPageDownloadItem(const QString &html, QObject *parent): AbstractDownloadItem(parent), _html(html)
{
    this->setFileName(WebPageDownloadItem::DEFAULT_FILENAME);
    this->setProgressTotal(html.length());

    emit progressTotalChanged();
}

void WebPageDownloadItem::start()
{
    QFile f(QString("%1%2%3").arg(this->downloadPath(), QDir::separator(), this->fileName()));
    f.open(QFile::WriteOnly | QFile::Truncate);
    f.write(this->_html.toUtf8());
    f.close();

    this->setCompleted(true);
    this->setError(false);
    this->setProgressValue(this->_html.length());

    emit progressValueChanged();
    emit downloadCompleted(this->fileName());
}

void WebPageDownloadItem::cancel()
{
    this->setCompleted(true);
}
