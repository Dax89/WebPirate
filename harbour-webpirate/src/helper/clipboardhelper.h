#ifndef CLIPBOARDHELPER_H
#define CLIPBOARDHELPER_H

#include <QObject>

// Workaround for Clipboard Issues
class ClipboardHelper : public QObject
{
    Q_OBJECT

    public:
      explicit ClipboardHelper(QObject *parent = 0);

    public slots:
      void copy(const QString& text);
};

#endif // CLIPBOARDHELPER_H
