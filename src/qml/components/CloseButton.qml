import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Item {
    id: root

    height: 40; width: 40
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 60

    signal clicked()
    property alias mouseArea: mouseArea
    property alias text: label.text

    Rectangle {
        id: closeButton
        anchors.fill: parent

        opacity: 0.50
        color: "black"
        radius: parent.width

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    Label {
        id: label
        anchors.centerIn: closeButton
        text: "X"
        font.family: "Arial"
        font.bold: true
    }
}
