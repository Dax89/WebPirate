#ifndef AES256_H
#define AES256_H

#include <openssl/conf.h>
#include <openssl/err.h>
#include <openssl/evp.h>
#include <openssl/aes.h>
#include <time.h>
#include <QtCore>
#include <QtQml>
#include <QDebug>

class AES256: public QObject
{
    Q_OBJECT

    private:
        enum InitType { Encode = 0, Decode = 1 };

    public:
        explicit AES256(QObject* parent = 0);
        virtual ~AES256();

    public:
        static QObject *initialize(QQmlEngine*, QJSEngine*);

    private:
        qreal random();
        QByteArray generateSalt(int num);
        bool init(const QString& keydata, const QByteArray &salt, EVP_CIPHER_CTX* cipher, AES256::InitType inittype);

    public slots:
        QString encode(const QString& s, const QString& key);
        QString decode(const QString& s, const QString& key);
};

#endif // AES256_H
