#include "aes256.h"

AES256::AES256(QObject *parent): QObject(parent)
{
    qsrand(static_cast<uint>(time(NULL))); /* Activates the generator */

    ERR_load_crypto_strings();
    OpenSSL_add_all_algorithms();
    OPENSSL_config(NULL);
}

AES256::~AES256()
{

}

QObject* AES256::initialize(QQmlEngine*, QJSEngine*)
{
    return new AES256();
}

qreal AES256::random()
{
    return rand() / static_cast<qreal>(RAND_MAX);
}

QByteArray AES256::generateSalt(int num)
{
    QByteArray ba;
    ba.reserve(num);

    for(int i = 0; i < num; i++)
        ba[i] = (qFloor(this->random() * 256));

    return ba;
}

bool AES256::init(const QString &keydata, const QByteArray &salt, EVP_CIPHER_CTX* cipher, AES256::InitType inittype)
{
    unsigned char key[32], iv[32];

    int i = EVP_BytesToKey(EVP_aes_256_cbc(), EVP_md5(), reinterpret_cast<const unsigned char*>(salt.constData()),
                           reinterpret_cast<const unsigned char*>(keydata.toUtf8().constData()), keydata.length(), 1, key, iv);

    if(i != 32)
    {
        qWarning() << Q_FUNC_INFO << "Key size is" << i << "bits (should be 256)";
        return false;
    }

    switch(inittype)
    {
        case AES256::Encode:
            EVP_CIPHER_CTX_init(cipher);
            EVP_EncryptInit_ex(cipher, EVP_aes_256_cbc(), NULL, key, iv);
            break;

        case AES256::Decode:
            EVP_CIPHER_CTX_init(cipher);
            EVP_DecryptInit_ex(cipher, EVP_aes_256_cbc(), NULL, key, iv);
            break;

        default:
            qWarning() << Q_FUNC_INFO << "Invalid Initialization Type";
            return false;
    }

    return true;
}

QString AES256::encode(const QString &s, const QString &key)
{
    static char saltblock[] = { 83, 97, 108, 116, 101, 100, 95, 95 };
    EVP_CIPHER_CTX cipher;
    QByteArray salt = this->generateSalt(8);

    if(!this->init(key, salt, &cipher, AES256::Encode))
    {
        qWarning() << Q_FUNC_INFO << "Initialization Failed";
        return QString();
    }

    int len = s.length() + AES_BLOCK_SIZE, finallen = 0;
    QByteArray result(len, 0x00);

    EVP_EncryptInit_ex(&cipher, NULL, NULL, NULL, NULL);
    EVP_EncryptUpdate(&cipher, reinterpret_cast<unsigned char*>(result.data()), &len, reinterpret_cast<const unsigned char*>(s.toUtf8().constData()), s.length());
    EVP_EncryptFinal_ex(&cipher, reinterpret_cast<unsigned char*>(result.data() + len), &finallen);
    EVP_CIPHER_CTX_cleanup(&cipher);

    result.resize(len + finallen);
    salt.prepend(saltblock, 8);
    return QString::fromUtf8(result.prepend(salt).toBase64());
}

QString AES256::decode(const QString &s, const QString &key)
{
    EVP_CIPHER_CTX cipher;
    QByteArray cipheredtext = QByteArray::fromBase64(s.toUtf8());
    QByteArray salt = cipheredtext.mid(8, 8);

    if(!this->init(key, salt, &cipher, AES256::Decode))
    {
        qWarning() << Q_FUNC_INFO << "Initialization Failed";
        return QString();
    }

    cipheredtext = cipheredtext.mid(16);
    int len = cipheredtext.length(), finallen = 0;
    QByteArray result(len, 0x00);

    EVP_DecryptInit_ex(&cipher, NULL, NULL, NULL, NULL);
    EVP_DecryptUpdate(&cipher, reinterpret_cast<unsigned char*>(result.data()), &len, reinterpret_cast<const unsigned char*>(cipheredtext.constData()), cipheredtext.length());
    EVP_DecryptFinal_ex(&cipher, reinterpret_cast<unsigned char*>(result.data() + len), &finallen);
    EVP_CIPHER_CTX_cleanup(&cipher);

    result.resize(len + finallen);
    return QString(result);
}

