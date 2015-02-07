#ifndef ADBLOCKMANAGER_H
#define ADBLOCKMANAGER_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QDebug>

class AdBlockManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString rulesFile READ rulesFile NOTIFY rulesChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

    public:
        explicit AdBlockManager(QObject *parent = 0);
        QFile& rulesFileInstance();
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

    public:
        static const QString ADBLOCK_FOLDER;
        static const QString CSS_FILENAME;
        static const QString TABLE_FILENAME;

    private:
        bool _enabled;
        QString _rulesfile;
        QString _tablefile;
        QFile _rulefileinstance;
};

#endif // ADBLOCKMANAGER_H
