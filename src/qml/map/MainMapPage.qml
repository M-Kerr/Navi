import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import com.mkerr.navi 1.0
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import "../components"

Item {
    id: root

    property bool following
    property bool traffic
    property bool night

    // NOTE Allows zoom level dev tool to read map. delete for release
    property alias map: map

    Item {
        id: mapWindow
        anchors.fill: parent

        property var currentCoordinate: nmeaLog.coordinate

        Binding {
            target: EsriSearchModel
            property: "searchLocation"
            value: mapWindow.currentCoordinate
        }

        states: [
            State {
                name: ""
                PropertyChanges { target: map; tilt: 0; bearing: 0; zoomLevel: map.zoomLevel }
            },
            State {
                name: "following"
                // TODO: Change tilt and zoomLevel to more comfortable values
                PropertyChanges { target: map; tilt: 60; zoomLevel: 20 }
            }
        ]

        transitions: [
            Transition {
                to: "*"
                RotationAnimation { target: map; property: "bearing"; duration: 100; direction: RotationAnimation.Shortest }
                NumberAnimation { target: map; property: "zoomLevel"; duration: 100 }
                NumberAnimation { target: map; property: "tilt"; duration: 100 }
            }
        ]

        state: root.following ? "following" : ""

        NmeaLog {
            id: nmeaLog
            //        logFile: "://output.nmea.txt"
            logFile: "/Volumes/Sierra/Users/mdkerr/Programming/Projects/Navi/\
src/qml/resources/output.nmea.txt"

            Component.onCompleted: {
                startUpdates()
            }
        }

        Image {
            anchors.fill: parent
            z: 2

            //        source: "qrc:edge-gradient.png"
            source: "../resources/edge-gradient.png"
            opacity: 0.7
            visible: root.following
        }

        //    CustomLabel {
        //        id: turnInstructions

        //        anchors.top: parent.top
        //        anchors.horizontalCenter: parent.horizontalCenter
        //        anchors.margins: 20
        //        z: 3

        //        font.pixelSize: 38
        //    }


        Image {
            height: 80
            width: 80
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 20
            z: 3
            visible: !root.following
            //        source: "qrc:car-focus.png"
            source: "../resources/car-focus.png"

            MouseArea {
                id: area
                anchors.fill: parent
                onClicked: {
                    root.following = true
                }
            }

            scale: area.pressed ? 0.85 : 1.0

            Behavior on scale {
                NumberAnimation {}
            }
        }

        Map {
            id: map
            anchors.fill: parent

            function centerView(itemCoordinate) {
                map.center = itemCoordinate
                map.zoomLevel = 18.5
            }

            Connections {
                target: EsriSearchModel
                function onPlaceSelected(modelItem) {
                    map.centerView(modelItem.place.location.coordinate)
                }
            }

            plugin: MapboxPlugin
            activeMapType: {
                var style;

                if (root.following) {
                    style = root.night ? supportedMapTypes[1] : supportedMapTypes[0];
                } else {
                    style = root.night ? supportedMapTypes[3] : supportedMapTypes[2];
                }

                return style;
            }

            // WARNING: Dev environment only, not meant for production
            center: root.following ? mapWindow.currentCoordinate : map.center;
            //                        positionSource.position.coordinate : map.center;

            zoomLevel: 12.25
            minimumZoomLevel: 0
            maximumZoomLevel: 20
            tilt: 60

            copyrightsVisible: false

            MouseArea {
                anchors.fill: parent

                onClicked: parent.focus = true

                onWheel: {
                    root.following = false
                    wheel.accepted = false
                }
            }

            gesture.onPanStarted: {
                root.following = false
            }

            gesture.onPinchStarted: {
                root.following = false
            }

            RotationAnimation on bearing {
                id: bearingAnimation

                duration: 250
                alwaysRunToEnd: false
                direction: RotationAnimation.Shortest
                running: root.following
            }

            Location {
                id: previousLocation
                coordinate: QtPositioning.coordinate(0, 0);
            }

            onCenterChanged: {
                if (previousLocation.coordinate === center || !root.following)
                    return;

                bearingAnimation.to = previousLocation.coordinate.azimuthTo(center);
                bearingAnimation.start();

                previousLocation.coordinate = center;
            }

            //        function updateRoute() {
            //            routeQuery.clearWaypoints();
            //            routeQuery.addWaypoint(startMarker.coordinate);
            //            routeQuery.addWaypoint(endMarker.coordinate);
            //        }

            //        MapQuickItem {
            //            id: endMarker

            //            sourceItem: Image {
            //                id: redMarker
            //                source: "qrc:///marker-red.png"
            //            }

            //            coordinate : QtPositioning.coordinate(37.326323, -121.8923447)
            //            anchorPoint.x: redMarker.width / 2
            //            anchorPoint.y: redMarker.height / 2

            //            MouseArea  {
            //                drag.target: parent
            //                anchors.fill: parent

            //                onReleased: {
            //                    map.updateRoute();
            //                }
            //            }
            //        }

//            MapItemView {
//                model: routeModel

//                delegate: MapRoute {
//                    route: routeData
//                    line.color: "#ec0f73"
//                    line.width: map.zoomLevel - 5
//                    opacity: (index == 0) ? 1.0 : 0.3

//                    //onRouteChanged: {
//                    //ruler.path = routeData.path;
//                    //ruler.currentDistance = 0;

//                    //currentDistanceAnimation.stop();
//                    //currentDistanceAnimation.to = ruler.distance;
//                    //currentDistanceAnimation.start();
//                    //}
//                }
//            }

            MapQuickItem {
                sourceItem: Image {
                    id: carMarker
                    //                source: "qrc:///current-location.png"
                    source: "../resources/current-location.png"
                }

                zoomLevel: map.zoomLevel
                coordinate: mapWindow.currentCoordinate
                anchorPoint.x: carMarker.width / 2
                anchorPoint.y: carMarker.height / 2
            }

            // WARNING: dev tool, delete and replace with PlacesMapView
            property var placesMap: null
            // Dynamically insert a PlacesMapView into the Map
            function createPlacesMapView () {
                // remove the current placesmap
                if (placesMap) {
                    map.removeMapItemView(placesMap)
                    placesMap.destroy()
                }

                placesMap = null
                $QmlEngine.clearCache();
                var comp = Qt.createComponent("../components/PlacesMapView.qml")
                placesMap = comp.createObject(map, {})
                map.addMapItemView(placesMap)
                print("PlacesMapView component updated")
            }

            Component.onCompleted: {
                createPlacesMapView()
            }

            Shortcut {
                id: placesMapReloader
                sequence: "F5"
                context: Qt.ApplicationShortcut
                onActivated: {
                    print("PlacesMapView reload activated")
                    map.createPlacesMapView()
                }
                onActivatedAmbiguously: activated();
            }
            //        PlacesMapView {
            //            id: placesMap
            //        }


        }

        PullPane {
            id: placeInfoPane

            Connections {
                target: EsriSearchModel
                function onPlaceSelected(modelItem) {
                    placeInfoPane.modelItem = modelItem
                }
            }
        }

//        RouteModel {
//            id: routeModel

//            autoUpdate: true
//            query: routeQuery
//            plugin: plugin
            //        plugin: Plugin {
            //            name: "mapbox"

            //            PluginParameter {
            //                name: "mapbox.access_token"
            //                //     WARNING: Dev environment only, not meant for production
            //                value: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
            //            }
            //        }

            //        Component.onCompleted: {
            //            if (map) {
            //                map.updateRoute();
            //            }
            //        }
//        }
//        RouteQuery {
//            id: routeQuery
//        }

    }
}
