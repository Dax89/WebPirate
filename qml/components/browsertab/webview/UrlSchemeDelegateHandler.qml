import QtQuick 2.1

QtObject
{
    function handleProtocol(protocol, url)
    {
        if(protocol === "mailto")
        {
            mainwindow.settings.urlcomposer.mailTo(url);
            return true;
        }

        if(protocol === "sms")
        {
            mainwindow.settings.urlcomposer.send(url);
            return true;
        }

        if(protocol === "tel")
        {
            mainwindow.settings.urlcomposer.compose(url);
            return true;
        }

        return false;
    }
}
