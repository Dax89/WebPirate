#ifndef VOICECALL_H
#define VOICECALL_H

#include <QObject>
#include <QtDBus>

class VoiceCall : public QObject
{
    Q_OBJECT

    public:
        explicit VoiceCall(QObject *parent = 0);

    public slots:
        void compose(const QString& tel);
};

#endif // VOICECALL_H
