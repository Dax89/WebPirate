#ifndef ADBLOCKFILTER_H
#define ADBLOCKFILTER_H

#include <QObject>
#include <QFile>

class AdBlockFilter: public QObject
{
    Q_OBJECT

    public:
        enum Type { RangeFilter = 0, CreatedFilter = 1 };

    public:
        explicit AdBlockFilter(qint64 pos, qint64 length, QObject *parent = 0);
        explicit AdBlockFilter(const QString& filter, QObject *parent = 0);
        AdBlockFilter::Type filterType() const;
        void updateFilter(const QString& s);
        QString readFilter(QFile& f);

    private:
        AdBlockFilter::Type _filtertype;
        qint64 _pos;
        qint64 _length;
        QString _filter;
};

#endif // ADBLOCKFILTER_H
