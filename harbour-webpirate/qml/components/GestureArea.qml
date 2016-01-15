import QtQuick 2.1

MouseArea
{
    signal swypeLeft()
    signal swypeUp()
    signal swypeRight()
    signal swypeDown()

    readonly property bool verticalGesture: gestureareaprivate.velocityY > gestureareaprivate.velocityX
    readonly property bool horizontalGesture: gestureareaprivate.velocityX > gestureareaprivate.velocityY
    readonly property bool gestureRunning: gestureareaprivate.velocity > gesturearea.threshold
    property real threshold: 15

    QtObject
    {
        property bool tracing: false
        property real velocityX: 0
        property real velocityY: 0
        property real velocity: 0
        property real prevX: 0
        property real prevY: 0

        function resetGesture() {
            gestureareaprivate.tracing = false;
            gestureareaprivate.prevX = 0;
            gestureareaprivate.prevY = 0;
            gestureareaprivate.velocityX = 0;
            gestureareaprivate.velocityY = 0;
            gestureareaprivate.velocity = 0;
        }

        id: gestureareaprivate
    }

    id: gesturearea

    onPressed: {
        gestureareaprivate.tracing = true;
        gestureareaprivate.prevX = mouseX;
        gestureareaprivate.prevY = mouseY;
    }

    onReleased: {
        if(gesturearea.horizontalGesture) {
            if((gestureareaprivate.velocity > gesturearea.threshold) && (mouseX > parent.width * 0.2)) {
                swypeRight();
            }
            else if((gestureareaprivate.velocity < gesturearea.threshold) && (mouseX < parent.width * 0.2)) {
                swypeLeft();
            }
        }

        if(gesturearea.verticalGesture) {
            if((gestureareaprivate.velocity > gesturearea.threshold) && (mouseY > parent.height * 0.2)) {
                swypeDown();
            }
            else if((gestureareaprivate.velocity < gesturearea.threshold) && (mouseY < parent.height * 0.2)) {
                swypeUp();
            }
        }

        gestureareaprivate.resetGesture();
    }

    onPositionChanged: {
        if(!gestureareaprivate.tracing)
            return;

        gestureareaprivate.velocityX = (mouseX - gestureareaprivate.prevX);
        gestureareaprivate.velocityY = (mouseY - gestureareaprivate.prevY);
        gestureareaprivate.velocity = (gestureareaprivate.velocity + Math.max(gestureareaprivate.velocityX, gestureareaprivate.velocityY)) / 2.0;
        gestureareaprivate.prevX = mouseX;
        gestureareaprivate.prevY = mouseY;

        if(gesturearea.horizontalGesture) {
            if((gestureareaprivate.velocity > gesturearea.threshold) && (mouseX > parent.width * 0.2)) {
                gestureareaprivate.resetGesture();
                swypeRight();
            }
            else if((gestureareaprivate.velocity < gesturearea.threshold) && (mouseX < parent.width * 0.2)) {
                gestureareaprivate.resetGesture();
                swypeLeft();
            }
        }

        if(gesturearea.verticalGesture) {
            if((gestureareaprivate.velocity > gesturearea.threshold) && (mouseY > parent.height * 0.2)) {
                gestureareaprivate.resetGesture();
                swypeDown();
            }
            else if((gestureareaprivate.velocity < gesturearea.threshold) && (mouseY < parent.height * 0.2)) {
                gestureareaprivate.resetGesture();
                swypeUp();
            }
        }

    }
}
