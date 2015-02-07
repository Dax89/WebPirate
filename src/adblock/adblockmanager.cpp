#include "adblockmanager.h"

const QString AdBlockManager::ADBLOCK_FOLDER = "AdBlock";
const QString AdBlockManager::RULES_FILENAME = "adblock.css";
const QString AdBlockManager::TABLE_FILENAME = "adblock.table";

AdBlockManager::AdBlockManager(QObject *parent): QObject(parent), _enabled(false)
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.exists(AdBlockManager::ADBLOCK_FOLDER))
        datadir.mkdir(AdBlockManager::ADBLOCK_FOLDER);

    datadir.cd(AdBlockManager::ADBLOCK_FOLDER);
    this->_rulesfile = datadir.filePath(AdBlockManager::RULES_FILENAME);
    this->_tablefile = datadir.filePath(AdBlockManager::TABLE_FILENAME);

    if(!datadir.exists(AdBlockManager::RULES_FILENAME))
        this->createEmptyRulesFile();

    if(!datadir.exists(AdBlockManager::TABLE_FILENAME))
        this->createEmptyTableFile();
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
    f.open(QFile::ReadOnly);
    f.write("Count: 0");
    f.close();
}

void AdBlockManager::saveFilters()
{

}

void AdBlockManager::downloadFilters()
{

}
