#include "adblockmanager.h"

const QString AdBlockManager::ADBLOCK_FOLDER = "AdBlock";
const QString AdBlockManager::CSS_FILENAME = "adblock.css";
const QString AdBlockManager::TABLE_FILENAME = "adblock.table";
const QString AdBlockManager::HOSTS_FILENAME = "hosts.rgx";
const QString AdBlockManager::HOSTS_FILENAME_TMP = "hosts.tmp";

AdBlockManager::AdBlockManager(QObject *parent): QObject(parent), _enabled(false)
{
    QDir datadir = QDir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));

    if(!datadir.exists(AdBlockManager::ADBLOCK_FOLDER))
        datadir.mkdir(AdBlockManager::ADBLOCK_FOLDER);

    datadir.cd(AdBlockManager::ADBLOCK_FOLDER);
    this->_rulesfile = datadir.filePath(AdBlockManager::CSS_FILENAME);
    this->_tablefile = datadir.filePath(AdBlockManager::TABLE_FILENAME);
    this->_hostsfile = datadir.filePath(AdBlockManager::HOSTS_FILENAME);
    this->_hostsfiletmp = datadir.filePath(AdBlockManager::HOSTS_FILENAME_TMP);
    this->_rulefileinstance.setFileName(this->_rulesfile);

    if(QFile::exists(this->_hostsfile))
        this->updateHostsBlackList();

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

QString AdBlockManager::hostsBlackList()
{
    if(this->_hostsblacklist.isEmpty())
        this->updateHostsBlackList();

    return this->_hostsblacklist;
}

const QString& AdBlockManager::cssFile() const
{
    return this->_rulesfile;
}

const QString& AdBlockManager::tableFile() const
{
    return this->_tablefile;
}

const QString &AdBlockManager::hostsRgxFile() const
{
    return this->_hostsfile;
}

const QString &AdBlockManager::hostsTmpFile() const
{
    return this->_hostsfiletmp;
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

bool AdBlockManager::updateHostsBlackList()
{
    QFile f(this->_hostsfile);

    if(!f.exists())
    {
        emit hostsBlackListChanged();
        return false;
    }

    f.open(QFile::ReadOnly);
    this->_hostsblacklist = f.readAll();
    f.close();

    emit hostsBlackListChanged();
    return true;
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
