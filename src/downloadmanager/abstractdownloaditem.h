#ifndef ABSTRACTDOWNLOADITEM_H
#define ABSTRACTDOWNLOADITEM_H

#include <QObject>
#include <QUrl>
#include <QDir>
#include <QTimer>
#include <QStandardPaths>

class AbstractDownloadItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(const QUrl& url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(bool completed READ completed NOTIFY completedChanged)
    Q_PROPERTY(bool error READ error NOTIFY errorChanged)
    Q_PROPERTY(qint64 progressValue READ progressValue NOTIFY progressValueChanged)
    Q_PROPERTY(qint64 progressTotal READ progressTotal NOTIFY progressTotalChanged)
    Q_PROPERTY(const QString& fileName READ fileName NOTIFY fileNameChanged)
    Q_PROPERTY(const QString& speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(const QString& lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(const QString& downloadPath READ downloadPath CONSTANT FINAL)

    public:
        explicit AbstractDownloadItem(QObject *parent = 0);
        explicit AbstractDownloadItem(const QUrl& url, QObject *parent = 0);

    public:
        const QUrl& url() const;
        bool completed() const;
        bool error() const;
        qint64 progressValue() const;
        qint64 progressTotal() const;
        const QString& fileName() const;
        const QString& speed() const;
        const QString& lastError() const;
        const QString& downloadPath() const;
        QString completePath() const;

    private:
        void adjust(QString& filename);
        void checkConflicts(QString& filename);
        void setSpeed(const QString& speed);

    private slots:
        void onTimeout();
        void stopTimer();

    protected:
        void setUrl(const QUrl& url);
        void setCompleted(bool b);
        void setError(bool b);
        void setProgressValue(qint64 progressvalue);
        void setProgressTotal(qint64 progresstotal);
        void setFileName(const QString& filename);
        void setLastError(const QString& lasterror);
        void updateBytesReceived(qint64 bytesreceived);

    public slots:
        virtual void start();
        virtual void cancel();

    signals:
        void downloadCompleted(const QString& filename);
        void downloadFailed(const QString& filename);
        void urlChanged();
        void completedChanged();
        void errorChanged();
        void progressValueChanged();
        void progressTotalChanged();
        void fileNameChanged();
        void speedChanged();
        void lastErrorChanged();

    private:
        QUrl _url;
        bool _completed;
        bool _error;
        qint64 _bytesreceived;
        qint64 _progressvalue;
        qint64 _progresstotal;
        QString _filename;
        QString _speed;
        QString _lasterror;
        QString _downloadpath;
        QTimer _downloadtimer;
};

#endif // ABSTRACTDOWNLOADITEM_H
