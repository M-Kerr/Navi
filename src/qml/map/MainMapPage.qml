import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import com.mkerr.navi 1.0
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import "../components"

Item {
    id: mainMapPage

    property bool following
    property bool traffic
    property bool night
    property color bgColor

    // NOTE Allows zoom level dev tool to read map. delete for release
    property alias map: map
    property string previousState: ""

    MainMapPageStates{id: mainMapPageStates}
    states: mainMapPageStates.states
    transitions: mainMapPageStates.transitions
    state: ""

    StackView.visible: true
    StackView.onActivating: {
        state = previousState
        searchBar.enabled = true
    }
    StackView.onDeactivating: searchBar.enabled = false
    SearchBar {
        id: searchBar
        z: 2

        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.75

        bgColor: parent.bgColor

        Binding {
            target: EsriSearchModel
            property: "searchTerm"
            value: searchBar.text
        }
    }

    SearchPage {
        id: searchPage
        visible: false
        z: 1

        anchors.bottom: parent.top
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        bgColor: parent.bgColor
        night: parent.night
    }

    Item {
        id: mapWindow
        anchors.fill: parent

        property var currentCoordinate: nmeaLog.coordinate

        Binding {
            target: EsriSearchModel
            property: "searchLocation"
            value: mapWindow.currentCoordinate
        }

        MainMapStates { id: mainMapStates }
        states: mainMapStates.states
        transitions: mainMapStates.transitions
        state: mainMapPage.following ? "following" : ""

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
            visible: mainMapPage.following
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
            visible: !mainMapPage.following
            //        source: "qrc:car-focus.png"
            source: "../resources/car-focus.png"

            MouseArea {
                id: area
                anchors.fill: parent
                onClicked: {
                    mainMapPage.following = true
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
                    previousState = state
                    state = ""
                }
            }

            plugin: MapboxPlugin
            activeMapType: {
                var style;

                if (mainMapPage.following) {
                    style = mainMapPage.night ? supportedMapTypes[1] : supportedMapTypes[0];
                } else {
                    style = mainMapPage.night ? supportedMapTypes[3] : supportedMapTypes[2];
                }

                return style;
            }

            // WARNING: Dev environment only, not meant for production
            center: mainMapPage.following ? mapWindow.currentCoordinate : map.center;
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
                    mainMapPage.following = false
                    wheel.accepted = false
                }
            }

            gesture.onPanStarted: {
                mainMapPage.following = false
            }

            gesture.onPinchStarted: {
                mainMapPage.following = false
            }

            RotationAnimation on bearing {
                id: bearingAnimation

                duration: 250
                alwaysRunToEnd: false
                direction: RotationAnimation.Shortest
                running: mainMapPage.following
            }

            Location {
                id: previousLocation
                coordinate: QtPositioning.coordinate(0, 0);
            }

            onCenterChanged: {
                if (previousLocation.coordinate === center || !mainMapPage.following)
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
