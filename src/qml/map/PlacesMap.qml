import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import MapboxPlugin 1.0
import MapboxSearchModel 1.0
import GlobalStatus 1.0

MapItemView {
    id: mapItemView
    model: MapboxSearchModel

    delegate: //Component {
        MapQuickItem {
            id: mapQuickItem

            function select() {
                map.center = place.location.coordinate
            }

            coordinate: place.location.coordinate
            anchorPoint.x: loader.width * 0.5
            anchorPoint.y: loader.height

            sourceItem: Loader {
                id: loader

                sourceComponent: type === PlaceSearchModel.PlaceResult ? placeResult : null

                Component {
                    id: placeResult

                    // TODO: place a loader on top that animates up an info
                    // box onClicked.

                    Item {
                        id: resultItem
                        height: 90
                        width: 60

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
                            onClicked: mapQuickItem.select()
                        }
                    }
                }
            }
//        }
    }
}
