import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Item {
    id: root

    height: 40; width: 40
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 60

    Rectangle {
        id: backButton
        anchors.fill: parent

        opacity: 0.50
        color: "black"
        radius: parent.width

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainMapPage.map.fitViewportToMapItems()
                stackView.pop()
            }
        }
    }
    Label {
        anchors.centerIn: backButton
        text: "≺"
        font.family: "Arial"
        font.bold: true
    }
}
