#ifndef URLCOMPOSER_H
#define URLCOMPOSER_H

#include <QObject>
#include <QtDBus>

class UrlComposer : public QObject
{
    Q_OBJECT

    public:
        explicit UrlComposer(QObject *parent = 0);

    public slots:
        void compose(const QString& tel) const;
        void send(const QString& sms) const;
        void mailTo(const QString& mail) const;
};

#endif // URLCOMPOSER_H
