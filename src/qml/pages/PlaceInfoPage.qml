import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"

Page {
    id: placeInfoPage

    background: Item {}

    // TODO refactor PullPane into a component
    // and implement its details within PlaceInfoPage.
    // TODO Refactor PullPane's footer into placeInfoPage's footer
    BackButton {
        id: backButton
        onClicked: {
            placeInfoPage.StackView.view.fitViewportToMapItems()
            placeInfoPage.StackView.view.pop()
        }
    }

    CloseButton {
        id: closeButton
        onClicked: {
            placeInfoPage.StackView.view.fitViewportToMapItems()
            placeInfoPage.StackView.view.unwind()
        }
    }

    PullPane {
        id: placeInfoPane
    }
}
