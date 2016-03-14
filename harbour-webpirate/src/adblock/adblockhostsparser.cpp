#include "adblockhostsparser.h"
#include <QRegularExpression>
#include <QDebug>
#include <QFile>

AdBlockHostsParser::AdBlockHostsParser(QObject *parent) : QObject(parent)
{

}

void AdBlockHostsParser::parse(const QString &hoststmpfile, const QString &rgxfile)
{
    QString line;
    QString hostsstring;
    QRegularExpression hostsrgx("^0.0.0.0 ([\\S]+)");

    QFile hosts(hoststmpfile);
    hosts.open(QFile::ReadOnly);

    while(!hosts.atEnd())
    {
        line = hosts.readLine().trimmed();

        if(line.isEmpty() || (line.at(0) == '#'))
            continue;

        QRegularExpressionMatch match = hostsrgx.match(line);

        if(!match.hasMatch())
            continue;

        if(!hostsstring.isEmpty())
            hostsstring.append("|");

        hostsstring.append(match.captured(1));
    }

    hosts.close();
    hosts.remove(); // Delete temporary file

    QFile rgx(rgxfile);
    rgx.open(QFile::WriteOnly);
    rgx.write(hostsstring.toUtf8());
    rgx.close();
}

