import QtQuick 2.15
import QtQuick.Controls 2.15
import AppUtil 1.0
import "SoftUI"

Item {
    id: root

    height: 50; width: 50
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 60

    signal clicked()
    property alias mouseArea: mouseArea
    property alias text: label.text

    SoftGlassBox {
        id: softGlassBox

        source: mainMapPage
        anchors.fill: parent
        radius: parent.width
        blurRadius: 40
        color: AppUtil.color.background

        border {
            width: 3
            color: AppUtil.color.backgroundBorder
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    Label {
        id: label
        anchors.centerIn: softGlassBox
//        text: "≺"
        text: "<"
        font {
            family: "Arial"
            bold: true
            pixelSize: 20
        }
        color: AppUtil.color.fontSecondary
        background: Item {}
    }
}
