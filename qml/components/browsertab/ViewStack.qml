import QtQuick 2.1
import Sailfish.Silica 1.0
import "views"

Item
{
    QtObject
    {
        property ListModel model: ListModel { }

        id: stackobject

        function calculateMetrics()
        {
            if(viewstack.empty || !viewstack.visible)
                return;

            var topitem = top();
            topitem.width = viewstack.width;
            topitem.height = viewstack.height;
        }

        function top()
        {
            if(!viewstack.empty)
                return model.get(0).item;

            return null;
        }

        function push(item)
        {
            item.width = viewstack.width;
            item.height = viewstack.height;

            if(!empty)
                top().visible = false;

            model.insert(0, { "item": item });
            viewstack.opacity = 1.0;
        }

        function pop()
        {
            var item = model.get(0).item;
            model.remove(0);

            item.parent = null;
            item.destroy();

            if(!empty)
            {
                stackobject.calculateMetrics();
                stackobject.top().visible = true;
            }
        }
    }

    readonly property bool empty: stackobject.model.count === 0

    Component
    {
        id: loadfailedcomponent
        LoadFailed { }
    }

    Component
    {
        id: browserplayercomponent
        BrowserPlayer { }
    }

    function pushLoadError(errorstring, offline)
    {
        tabheader.solidify();
        navigationbar.solidify();

        var item = loadfailedcomponent.createObject(viewstack);
        item.errorString = errorstring;
        item.offline = offline;

        stackobject.push(item);
    }

    function pushBrowserPlayer(videosource)
    {
        var item = browserplayercomponent.createObject(viewstack);
        item.videoSource = videosource

        stackobject.push(item);
    }

    function clear()
    {
        stackobject.model.clear();
    }

    function pop()
    {
        if(!empty)
            stackobject.pop();

        if(empty)
            opacity = 0.0;
    }

    function replaceTop()
    {

    }

    Behavior on opacity {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    id: viewstack
    z: 2
    opacity: 0.0
    visible: opacity > 0.0
    onWidthChanged: stackobject.calculateMetrics()
    onHeightChanged: stackobject.calculateMetrics()

    onVisibleChanged: {
        if(visible)
            stackobject.calculateMetrics();
    }
}
