import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Item {
    id: root

    height: 40; width: 40
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 60

    signal clicked()
    property alias mouseArea: mouseArea

    Rectangle {
        id: backButton
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
        anchors.centerIn: backButton
        text: "≺"
        font.family: "Arial"
        font.bold: true
    }
}
