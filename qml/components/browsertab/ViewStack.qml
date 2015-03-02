import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    QtObject
    {
        property ListModel model: ListModel { }
        property var componentCache: ({ })
        property string originalTabState

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

        function erase(idx)
        {
            var item = model.get(idx).item;
            model.remove(idx);

            item.parent = null;
            item.destroy();
        }

        function pop()
        {
            erase(0);

            if(!empty)
            {
                stackobject.calculateMetrics();
                stackobject.top().visible = true;
            }
        }
    }

    readonly property bool empty: stackobject.model.count === 0

    onEmptyChanged: {
        if(!empty && (stackobject.model.count === 1))
            stackobject.originalTabState = browsertab.state;
        else if(empty)
            browsertab.state = stackobject.originalTabState;
    }

    function push(componenturl, tabstate, params)
    {
        var component = stackobject.componentCache[componenturl];

        if(!component)
            component = stackobject.componentCache[componenturl] = Qt.createComponent(componenturl);

        if(!component)
        {
            console.error("Cannot create component: " + componenturl);
            return;
        }

        var object = component.createObject(viewstack, params || { });
        stackobject.push(object);

        if(tabstate)
            browsertab.state = tabstate;

        return object;
    }

    function clear()
    {
        while(stackobject.model.count)
            stackobject.erase(0);
    }

    function pop()
    {
        if(!empty)
            stackobject.pop();

        if(empty)
            opacity = 0.0;
    }

    function replace(componenturl, tabstate, params)
    {
        stackobject.erase(0);
        push(componenturl, tabstate, params);
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
