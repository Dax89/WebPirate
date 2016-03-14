#ifndef ADBLOCKHOSTSPARSER_H
#define ADBLOCKHOSTSPARSER_H

#include <QObject>

class AdBlockHostsParser : public QObject
{
    Q_OBJECT

    public:
        explicit AdBlockHostsParser(QObject *parent = 0);
        void parse(const QString& hostsfile, const QString& rgxfile);
};

#endif // ADBLOCKHOSTSPARSER_H
