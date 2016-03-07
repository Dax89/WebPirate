#include "clipboardhelper.h"
#include <QGuiApplication>
#include <QClipboard>

ClipboardHelper::ClipboardHelper(QObject *parent) : QObject(parent)
{

}

void ClipboardHelper::copy(const QString &text)
{
    if(text.isEmpty())
        return;

    qApp->clipboard()->clear();
    qApp->clipboard()->setText(text);
}
