import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"
import "../components/SoftUI"

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
        color {
            hsvHue: 0.0
            hsvSaturation: 0.0
            hsvValue: 0.07
            a: 0.50
        }

        border {
            width: 3
            color {
                hsvHue: 0.0
                hsvSaturation: 0.0
                hsvValue: 0.60
                a: 0.60
            }
        }

        shadow {
//            visible: true
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
        background: Item {}
    }
}
