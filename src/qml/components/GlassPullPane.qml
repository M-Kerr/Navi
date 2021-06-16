import QtQuick 2.0
import AppUtil 1.0
import "qrc:///SoftUI"

SoftGlassBox {
    id: root

    property int minHeight: 150
    property int maxHeight: parent.height * 0.75
    property alias mouseArea: mouseArea

    readonly property alias dragging: internal.dragging

    height: minHeight
    anchors {
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }

    radius: 0
    color: AppUtil.color.background

    border {
        width: 0
        color: AppUtil.color.backgroundBorder
    }

    MouseArea {
        id: mouseArea
        anchors.fill:parent

        onPressed: {
            root.startDrag(mouse)
        }

        onReleased: root.stopDrag()

        onPositionChanged: {
            root.drag(mouse)
        }
    }

    QtObject {
        id: internal

        property bool dragging: false
        property real lastY
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
