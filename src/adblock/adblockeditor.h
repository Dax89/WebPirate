#ifndef ADBLOCKEDITOR_H
#define ADBLOCKEDITOR_H

#include <QObject>
#include <QFile>
#include <QPair>
#include <QRegExp>
#include "adblockmanager.h"
#include "adblockfilter.h"

class AdBlockEditor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int filtersCount READ filtersCount NOTIFY filtersCountChanged)

    private:
        typedef QPair<qint64, qint64> FilterPair;

    public:
        explicit AdBlockEditor(QObject *parent = 0);
        int filtersCount() const;
        ~AdBlockEditor();

    signals:
        void filtersCountChanged();

    public slots:
        QString filter(int i);
        void setFilter(int i, const QString& s);
        void addFilter(const QString& s);
        void deleteFilter(int idx);
        void saveFilters(AdBlockManager* adblockmanager);
        void loadFilters(AdBlockManager* adblockmanager);

    private:
        QStringList readAllFilters();
        void loadTable(const QString& tablefile);
        int parseCount(const QString& line);
        FilterPair parseFilter(const QString& line);

    private:
        QFile _cssfile;
        QList<AdBlockFilter*> _filters;
};

#endif // ADBLOCKEDITOR_H
