#ifndef ADBLOCKMANAGER_H
#define ADBLOCKMANAGER_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QNetworkAccessManager>
#include <QDebug>

class AdBlockManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString rulesFile READ rulesFile NOTIFY rulesChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    public:
        explicit AdBlockManager(QObject *parent = 0);
        QString rulesFile() const;
        const QString& cssFile() const;
        const QString& tableFile() const;
        bool enabled() const;
        void setEnabled(bool b);

    private:
        void createEmptyRulesFile();
        void createEmptyTableFile();

    signals:
        void enabledChanged();
        void rulesChanged();

    public slots:
        void saveFilters();
        void downloadFilters();

    private:
        bool _enabled;
        QString _rulesfile;
        QString _tablefile;
        QNetworkAccessManager nam;

    private:
        static const QString ADBLOCK_FOLDER;
        static const QString RULES_FILENAME;
        static const QString TABLE_FILENAME;
};

#endif // ADBLOCKMANAGER_H
