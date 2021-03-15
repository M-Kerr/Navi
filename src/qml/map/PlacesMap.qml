import QtQuick 2.0
import QtLocation 5.12
import MapboxPlugin 1.0
import MapboxSearchModel 1.0

MapItemView {
    id: mapItemView
    model: MapboxSearchModel
    autoFitViewport: true

    Component {
        id: delegateSourceItem

        // TODO: place a loader on top of the column that animates up an info
        // box onClicked.
        Item {
            anchors.fill: parent

            Column {
                anchors.fill:parent
                Image { id: image; source: "../resources/marker2.png" }
                Text { text: title; font.bold: true }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: select()
            }
        }
    }

    delegate: MapQuickItem {

        function select() {
            map.center = place.location.coordinate
        }

        coordinate: place.location.coordinate

        anchorPoint.x: image.width * 0.5
        anchorPoint.y: image.height

        sourceItem: delegateSourceItem
    }
}
