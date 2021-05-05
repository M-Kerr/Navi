import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import AppUtil 1.0
import "SoftUI"

SoftGlassBox {
    id: root

    signal clicked(var mouse)

    property alias mouseArea: mouseArea

    implicitHeight: 35
    implicitWidth: 35

    blurRadius: 40

    Image {
        id: backImage

        anchors {
            fill: parent
            margins: 11
        }

        visible: false
        source: "../resources/arrow.svg"
        rotation: -90
    }

    ColorOverlay {

        anchors.fill: source

        source: backImage
        color: AppUtil.color.foreground
        rotation: -90
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
