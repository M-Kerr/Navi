import QtQuick 2.15
import QtQuick.Controls 2.15
import AppUtil 1.0
import "SoftUI"

SoftGlassBox {
    id: root

    signal clicked(var mouse)

    property alias mouseArea: mouseArea
    property alias label: label
    property alias text: label.text

    implicitHeight: 35
    implicitWidth: 35

    blurRadius: 40

    Label {
        id: label

        anchors.centerIn: root

        text: "<"
        font {
            family: "Arial"
            bold: true
            pixelSize: 20
        }
        background: Item {}
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
