#ifndef ADBLOCKMANAGER_H
#define ADBLOCKMANAGER_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QStandardPaths>

class AdBlockManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString rulesFile READ rulesFile NOTIFY rulesChanged)
    Q_PROPERTY(QString hostsBlackList READ hostsBlackList NOTIFY hostsBlackListChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    public:
        explicit AdBlockManager(QObject *parent = 0);
        QFile& rulesFileInstance();
        QString rulesFile() const;
        QString hostsBlackList();
        const QString& cssFile() const;
        const QString& tableFile() const;
        const QString& hostsRgxFile() const;
        const QString& hostsTmpFile() const;
        bool enabled() const;
        void setEnabled(bool b);

    public:
        bool updateHostsBlackList();

    private:
        void createEmptyRulesFile();
        void createEmptyTableFile();

    signals:
        void enabledChanged();
        void rulesChanged();
        void hostsBlackListChanged();

    public:
        static const QString ADBLOCK_FOLDER;
        static const QString CSS_FILENAME;
        static const QString TABLE_FILENAME;
        static const QString HOSTS_FILENAME;
        static const QString HOSTS_FILENAME_TMP;

    private:
        bool _enabled;
        QString _rulesfile;
        QString _tablefile;
        QString _hostsfile;
        QString _hostsfiletmp;
        QString _hostsblacklist;
        QFile _rulefileinstance;
};

#endif // ADBLOCKMANAGER_H
