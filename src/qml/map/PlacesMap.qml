import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.15
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import GlobalStatus 1.0

MapItemView {
    id: mapItemView
    model: EsriSearchModel

    signal placeSelected (var modelItem);

    delegate: MapQuickItem {
        id: mapQuickItem

        coordinate: place.location.coordinate
        anchorPoint.x: 30
        anchorPoint.y: 50

        sourceItem: Loader {
            id: loader

            sourceComponent: type === PlaceSearchModel.PlaceResult ? placeResult : null

            Component {
                id: placeResult

                Item {
                    id: resultItem
                    height: 90
                    width: 60

                    // TODO: place a loader on top that animates up an info
                    // box onClicked.
                    property var markerInfoBox: null
                    function selectMarker() {
                        map.center = place.location.coordinate
                        map.zoomLevel = 18.5
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
                        id: imageItem
                        anchors.top: resultItem.top
                        anchors.left: resultItem.left
                        anchors.right: resultItem.right
                        height: 60

                        Image {
                            id: image;
                            anchors.fill: parent
                            source: {
                                if (place.icon.url().toString())
                                    //                            "qrc:///" + place.icon.url().toString().slice(7);
                                    "../resources/" + place.icon.url().toString().slice(7);

                                else "../resources/marker2.png"
                            }
                        }
                    }

                    Label {
                        id: resultTitle
                        anchors.top: imageItem.bottom
                        anchors.topMargin: 5
                        anchors.left: imageItem.left
                        anchors.right: imageItem.right
                        anchors.bottom: imageItem.bottom
                        text: title;
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
        //        }
    }
}
