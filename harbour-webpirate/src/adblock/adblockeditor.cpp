#include "adblockeditor.h"

AdBlockEditor::AdBlockEditor(QObject *parent): QObject(parent), _adblockmanager(NULL)
{

}

AdBlockManager *AdBlockEditor::manager()
{
    return this->_adblockmanager;
}

void AdBlockEditor::setManager(AdBlockManager *adblockmanager)
{
    this->_adblockmanager = adblockmanager;
}

void AdBlockEditor::loadFilters()
{
    this->loadTable(this->_adblockmanager->tableFile());
}

void AdBlockEditor::reload()
{
    this->_adblockmanager->rulesFileInstance().close();
    this->_filters.clear();

    this->loadFilters();
}

QStringList AdBlockEditor::readAllFilters()
{
    QStringList filters;
    QFile& cssfile = this->_adblockmanager->rulesFileInstance();

    for(int i = 0; i < this->_filters.length(); i++)
        filters.append(this->_filters[i]->readFilter(cssfile));

    return filters;
}

int AdBlockEditor::filtersCount() const
{
    return this->_filters.length();
}

QString AdBlockEditor::filter(int i)
{
    return this->_filters[i]->readFilter(this->_adblockmanager->rulesFileInstance());
}

void AdBlockEditor::setFilter(int i, const QString &s)
{
    this->_filters[i]->updateFilter(s);
    emit filtersCountChanged(); /* Update Filters */
}

void AdBlockEditor::addFilter(const QString &s)
{
    this->_filters.append(new AdBlockFilter(s, this));
    emit filtersCountChanged();
}

void AdBlockEditor::deleteFilter(int idx)
{
    this->_filters.removeAt(idx);
    emit filtersCountChanged();
}

void AdBlockEditor::saveFilters()
{
    QStringList filters = this->readAllFilters();
    QFile& cssfile = this->_adblockmanager->rulesFileInstance();
    cssfile.seek(0);   /* Move to begin */
    cssfile.resize(0); /* Clear CSS */

    QFile tablefile(this->_adblockmanager->tableFile());
    tablefile.open(QFile::WriteOnly | QFile::Truncate);
    tablefile.write(QString("Count: %1\n").arg(filters.length()).toLatin1());

    for(int i = 0; i < filters.length(); i++)
    {
        const QString& f = filters.at(i);
        tablefile.write(QString("[%1, %2]\n").arg(cssfile.pos()).arg(f.length()).toLatin1());

        if(i < (filters.length() - 1))
            cssfile.write(QString("%1, ").arg(f).toLatin1());
        else
            cssfile.write(f.toLatin1());
    }

    cssfile.write("\n{\n  display: none !important;\n}\n");
    tablefile.close();
}

AdBlockEditor::~AdBlockEditor()
{
    if(this->_adblockmanager->rulesFileInstance().isOpen())
        this->_adblockmanager->rulesFileInstance().close();
}

void AdBlockEditor::loadTable(const QString &tablefile)
{
    QFile f(tablefile);
    f.open(QFile::ReadOnly);

    QString line = f.readLine();

    if(!line.isEmpty())
    {
        int filterscount = this->parseCount(line);

        for(int i = 0; i < filterscount; i++)
        {
            if(f.atEnd())
                break;

            line = f.readLine();
            FilterPair fi = this->parseFilter(line);

            if(fi.first == -1 || fi.second == -1)
                continue; /* Invalid filter: Skip it */

            this->_filters.append(new AdBlockFilter(fi.first, fi.second, this));
        }
    }

    f.close();
    emit filtersCountChanged();
}

int AdBlockEditor::parseCount(const QString &line)
{
    QRegExp regex("Count:[ ]*([0-9]+)");
    int idx = regex.indexIn(line);

    if(idx == -1)
        return 0;

    return regex.cap(1).toInt();
}

AdBlockEditor::FilterPair AdBlockEditor::parseFilter(const QString &line)
{
    QRegExp regex("\\[([0-9]+), ([0-9]+)\\]");
    int idx = regex.indexIn(line);

    if(idx == -1)
        return FilterPair(-1, -1);

    return FilterPair(regex.cap(1).toInt(), regex.cap(2).toInt());
}

