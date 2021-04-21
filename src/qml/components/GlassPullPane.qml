import QtQuick 2.0
import "SoftUI"

SoftGlassBox {
    id: root

    property int minHeight: 150
    property int maxHeight: parent.height * 0.75
    property alias mouseArea: mouseArea

    height: minHeight
    anchors {
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }

    radius: 0
    color {
        hsvHue: 0
        hsvSaturation: 0
        hsvValue: 0.92
        a: 0.40
    }

    border {
        width: 0
    }

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
