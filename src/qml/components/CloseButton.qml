import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import AppUtil 1.0
import "qrc:///SoftUI"

SoftGlassBox {
    id: root

    signal clicked(var mouse)

    property alias mouseArea: mouseArea
    property alias imageColor: colorOverlay.color

    implicitHeight: 35
    implicitWidth: 35

    blurRadius: 40

    Image {
        id: closeImage

        anchors {
            fill: parent
            margins: 11
        }

        visible: false
        source: "../resources/close.png"
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: source

        source: closeImage
        color: AppUtil.color.foreground
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked(mouse)
    }

    Component.onCompleted: {
        color.a = 0.4
    }
}
