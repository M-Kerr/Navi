import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Page {
    id: placeInfoPage

    background: Item {}

    Rectangle {
        id: backButton

        height: 40; width: 40
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 60

        opacity: 0.50
        color: "black"
        radius: width

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainMapPage.map.fitViewportToMapItems()
                stackView.pop()
            }
        }
    }
    // Outside close button to not inherit opacity
    Label {
        anchors.centerIn: backButton
        text: "≺"
        font.family: "Arial"
        font.bold: true
    }

    Rectangle {
        id: closeButton

        height: 40; width: 40
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 60

        opacity: 0.50
        color: "black"
        radius: width

        // TODO: closeButton onClicked should fill the view with markers
        // (search entry remains)
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainMapPage.map.fitViewportToMapItems()
                stackView.unwind()
            }
        }
    }
    // Outside close button to not inherit opacity
    Label {
        anchors.centerIn: closeButton
        text: "X"
        font.family: "Arial"
        font.bold: true
    }

    PullPane {
        id: placeInfoPane
    }
}
