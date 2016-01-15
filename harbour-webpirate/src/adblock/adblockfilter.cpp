#include "adblockfilter.h"

AdBlockFilter::AdBlockFilter(qint64 pos, qint64 length, QObject *parent): QObject(parent), _filtertype(AdBlockFilter::RangeFilter), _pos(pos), _length(length)
{

}

AdBlockFilter::AdBlockFilter(const QString &filter, QObject *parent): QObject(parent), _filtertype(AdBlockFilter::CreatedFilter), _pos(-1), _length(0), _filter(filter)
{

}

AdBlockFilter::Type AdBlockFilter::filterType() const
{
    return this->_filtertype;
}

void AdBlockFilter::updateFilter(const QString &s)
{
    this->_filtertype = AdBlockFilter::CreatedFilter;
    this->_filter = s;
}

QString AdBlockFilter::readFilter(QFile &f)
{    
    if(this->_filtertype == AdBlockFilter::CreatedFilter)
        return this->_filter;

    if(this->_filter.isEmpty())
    {
        f.seek(this->_pos);
        this->_filter = f.read(this->_length); /* Cache filter for performance */
    }

    return this->_filter;
}
