#include "adblockmanager.h"

const QString AdBlockManager::ADBLOCK_FOLDER = "AdBlock";
const QString AdBlockManager::CSS_FILENAME = "adblock.css";
const QString AdBlockManager::TABLE_FILENAME = "adblock.table";

AdBlockManager::AdBlockManager(QObject *parent): QObject(parent), _enabled(false)
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.exists(AdBlockManager::ADBLOCK_FOLDER))
        datadir.mkdir(AdBlockManager::ADBLOCK_FOLDER);

    datadir.cd(AdBlockManager::ADBLOCK_FOLDER);
    this->_rulesfile = datadir.filePath(AdBlockManager::CSS_FILENAME);
    this->_tablefile = datadir.filePath(AdBlockManager::TABLE_FILENAME);
    this->_rulefileinstance.setFileName(this->_rulesfile);

    if(!datadir.exists(AdBlockManager::CSS_FILENAME))
        this->createEmptyRulesFile();

    if(!datadir.exists(AdBlockManager::TABLE_FILENAME))
        this->createEmptyTableFile();
}

QFile& AdBlockManager::rulesFileInstance()
{
    if(!this->_rulefileinstance.isOpen())
        this->_rulefileinstance.open(QFile::ReadWrite);

    return this->_rulefileinstance;
}

QString AdBlockManager::rulesFile() const
{
    if(!this->_enabled)
        return QString();

    return this->_rulesfile;
}

const QString& AdBlockManager::cssFile() const
{
    return this->_rulesfile;
}

const QString& AdBlockManager::tableFile() const
{
    return this->_tablefile;
}

bool AdBlockManager::enabled() const
{
    return this->_enabled;
}

void AdBlockManager::setEnabled(bool b)
{
    bool changed = b != this->_enabled;
    this->_enabled = b;

    if(changed)
    {
        emit enabledChanged();
        emit rulesChanged();
    }
}

void AdBlockManager::createEmptyRulesFile()
{
    QFile f(this->_rulesfile);
    f.open(QFile::WriteOnly);
    f.close();
}

void AdBlockManager::createEmptyTableFile()
{
    QFile f(this->_tablefile);
    f.open(QFile::WriteOnly);
    f.write("Count: 0\n");
    f.close();
}
