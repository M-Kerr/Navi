import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.15
import EsriSearchModel 1.0

MapItemView {
    id: mapItemView
    model: EsriSearchModel

    delegate: MapQuickItem {
        id: mapQuickItem

        coordinate: place.location.coordinate
        anchorPoint.x: 30
        anchorPoint.y: 50

        sourceItem: Loader {
            id: loader

            // Load a different component depending on search result type
            sourceComponent: type === PlaceSearchModel.PlaceResult ? placeResult : null

            Component {
                id: placeResult


                Item {
                    id: resultItem
                    height: 90
                    width: 60

                    property var markerInfoBox: null
                    function selectMarker() {

                        map.centerView(place.location.coordinate)

                        if (!markerInfoBox) {
                            var comp = Qt.createComponent("../components/MarkerDialog.qml")
                            if (comp.status !== Component.Ready) print(comp.errorString())
                            markerInfoBox = comp.createObject(map, {})
                            map.addMapItem(markerInfoBox)
                            markerInfoBox.closeAnimation.stopped.connect(deselectMarker)
                            markerInfoBox.focus = true
                        }
                    }

                    function deselectMarker() {
                        map.removeMapItem(markerInfoBox)
                        markerInfoBox.destroy()
                        markerInfoBox = null
                    }

                    Item {
                        id: markerItem
                        anchors.top: resultItem.top
                        anchors.left: resultItem.left
                        anchors.right: resultItem.right
                        height: 60

                        Image {
                            id: markerImage;
                            anchors.fill: parent
                            source: "../resources/marker2.png"
                        }
                    }

                    Label {
                        id: resultTitle
                        anchors.top: markerItem.bottom
                        anchors.topMargin: 5
                        anchors.left: markerItem.left
                        anchors.right: markerItem.right
                        anchors.bottom: markerItem.bottom
                        text:{
                            let i = place.name.indexOf(",")
                            if (i !== -1) place.name.slice(0, i);
                            else place.name
                        }
                        font.bold: true
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: resultItem.selectMarker()
                    }
                }
            }
        }
    }
}
