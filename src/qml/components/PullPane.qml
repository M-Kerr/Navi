import QtQuick 2.15

Rectangle {
    id: root

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: minHeight

    color: AppUtil.color.background

    property int minHeight: 150
    property int maxHeight: parent.height * 0.75
    property alias mouseArea: mouseArea

    readonly property alias dragging: internal.dragging

    QtObject {
        id: internal

        property bool dragging: false
        property real lastY
    }

    MouseArea {
        id: mouseArea
        anchors.fill:parent

        property bool dragging: false
        property real lastY

        onPressed: {
            root.startDrag(mouse)
        }

        onReleased: root.stopDrag()

        onPositionChanged: {
            root.drag(mouse)
        }
    }

    function startDrag (mouse) {
        internal.lastY = mouse.y
        internal.dragging = true
    }

    function stopDrag() {
        internal.dragging = false
    }

    function drag (mouse) {
        if (    internal.dragging
                && maxHeight > height + (internal.lastY - mouse.y)
                && height + (internal.lastY - mouse.y) > minHeight )
        {
            height += internal.lastY - mouse.y
        }
    }
}
