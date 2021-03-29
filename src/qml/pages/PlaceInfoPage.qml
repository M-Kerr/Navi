import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Page {
    id: placeInfoPage

    background: Item {}

    // TODO refactor buttons into components, refactor PullPane into a component
    // and implement its details within PlaceInfoPage.
    // TODO Refactor PullPane's footer into placeInfoPage's footer
    BackButton {
        id: backButton
        onClicked: {
            placeInfoPage.StackView.view.fitViewportToMapItems()
            placeInfoPage.StackView.view.pop()
        }
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
                placeInfoPage.StackView.view.fitViewportToMapItems()
                placeInfoPage.StackView.view.unwind()
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
