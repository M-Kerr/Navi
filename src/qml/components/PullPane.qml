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

    MouseArea {
        id: mouseArea
        anchors.fill:parent

        property bool dragging: false
        property real lastY

        onPositionChanged: {
            if (    dragging
                    && root.maxHeight > root.height + (lastY - mouse.y)
                    && root.height + (lastY - mouse.y) > root.minHeight )
            {
                root.height += lastY - mouse.y
            }
        }

        onPressed: {
            lastY = mouse.y
            dragging = true
        }

        onReleased: dragging = false
    }
}
