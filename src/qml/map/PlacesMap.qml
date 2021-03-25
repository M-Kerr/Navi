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

            // Load a different component depending on search result type
            sourceComponent: type === PlaceSearchModel.PlaceResult ? placeResult : null

            Component {
                id: placeResult


                Item {
                    id: resultItem
                    height: 90
                    width: 60

                    Component.onCompleted: {
                        switch (type) {
                        case PlaceSearchModel.UnknownSearchResult:
                            print("Result type unknown");
                            break;
                        case PlaceSearchModel.PlaceResult:
                            print ("Result type:", "Place")
                            break;
                        case PlaceSearchModel.ProposedSearchResult:
                            print("Result type:", "ProposedSearchResult")
                            break;
                        default: break;
                        }

                        let keys = place.contactDetails.keys()
                        console.error("Contact detail keys: ")
                        for ( let i=0; i < keys.length; i++)
                        {
                            console.error(keys[i] + ", ")
                        }


                    }

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
                            source: "../resources/marker2.png"
                        }
                    }

                    Label {
                        id: resultTitle
                        anchors.top: imageItem.bottom
                        anchors.topMargin: 5
                        anchors.left: imageItem.left
                        anchors.right: imageItem.right
                        anchors.bottom: imageItem.bottom
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
        //        }
    }
}
