import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import "../components"

Item {
    id: mapWindow

    property bool following
    property bool traffic
    property bool night
    property var plugin

    property var currentCoordinate: nmeaLog.coordinate
    property alias map: map

    Binding {
        target: EsriSearchModel
        property: "searchLocation"
        value: currentCoordinate
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

    state: following ? "following" : ""

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
        visible: following
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
        visible: !mapWindow.following
        //        source: "qrc:car-focus.png"
        source: "../resources/car-focus.png"

        MouseArea {
            id: area
            anchors.fill: parent
            onClicked: {
                mapWindow.following = true
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

        plugin: Plugin {
            name: "mapboxgl"

            PluginParameter {
                name: "mapboxgl.access_token"
                // WARNING: Dev environment only, not meant for production
                value: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
            }
            PluginParameter {
                // Renders route lines underneath labels
                name: "mapboxgl.mapping.items.insert_before"
                value: "road-label-small"
            }
            PluginParameter {
                name: "mapboxgl.mapping.additional_style_urls"
                value: "mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft,mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft"
                //                value: "mapbox://styles/mapbox/navigation-guidance-day-v4,mapbox://styles/mapbox/navigation-guidance-night-v4,mapbox://styles/mapbox/navigation-preview-day-v4,mapbox://styles/mapbox/navigation-preview-night-v4"
            }
        }

        activeMapType: {
            var style;

            if (mapWindow.following) {
                style = night ? supportedMapTypes[1] : supportedMapTypes[0];
            } else {
                style = night ? supportedMapTypes[3] : supportedMapTypes[2];
            }

            return style;
        }

        // WARNING: Dev environment only, not meant for production
        center: mapWindow.following ? mapWindow.currentCoordinate : map.center;
        //                        positionSource.position.coordinate : map.center;

        zoomLevel: 12.25
        minimumZoomLevel: 0
        maximumZoomLevel: 20
        tilt: 60

        copyrightsVisible: false

        // NOTE: the "traffic-*" layers are for viewing traffic data. They should
        // belong to the single road network component, Traffic property.

        // TODO: Delete this real-time paint and assign the color within the map studio
        //        DynamicParameter {
        //            type: "paint"
        //            property var layer: "building-extrusion"
        //            property var fillExtrusionColor: "#00617f"
        //            property var fillExtrusionOpacity: .6
        //            property var fillExtrusionHeight: { return { type: "identity", property: "height" } }
        //            property var fillExtrusionBase: { return { type: "identity", property: "min_height" } }
        //        }

        MouseArea {
            anchors.fill: parent

            onClicked: parent.focus = true

            onWheel: {
                mapWindow.following = false
                wheel.accepted = false
            }
        }

        gesture.onPanStarted: {
            mapWindow.following = false
        }

        gesture.onPinchStarted: {
            mapWindow.following = false
        }

        RotationAnimation on bearing {
            id: bearingAnimation

            duration: 250
            alwaysRunToEnd: false
            direction: RotationAnimation.Shortest
            running: mapWindow.following
        }

        Location {
            id: previousLocation
            coordinate: QtPositioning.coordinate(0, 0);
        }

        onCenterChanged: {
            if (previousLocation.coordinate === center || !mapWindow.following)
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

        MapItemView {
            model: routeModel

            delegate: MapRoute {
                route: routeData
                line.color: "#ec0f73"
                line.width: map.zoomLevel - 5
                opacity: (index == 0) ? 1.0 : 0.3

                //onRouteChanged: {
                //ruler.path = routeData.path;
                //ruler.currentDistance = 0;

                //currentDistanceAnimation.stop();
                //currentDistanceAnimation.to = ruler.distance;
                //currentDistanceAnimation.start();
                //}
            }
        }

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

        // WARNING: dev tool, delete and replace with PlacesMap
        property var placesMap: null
        function createPlacesMap () {
            // Dynamically insert a PlacesMap into the Map
            // remove the current placesmap
            if (placesMap) {
                map.removeMapItemView(placesMap)
                placesMap.destroy()
            }
            placesMap = null
            $QmlEngine.clearCache();
            var comp = Qt.createComponent("PlacesMap.qml")
            placesMap = comp.createObject(map, {})
            map.addMapItemView(placesMap)
            print("PlacesMap component updated")
        }
        Component.onCompleted: {
            createPlacesMap()
        }
        Shortcut {
            id: placesMapReloader
            sequence: "F5"
            context: Qt.ApplicationShortcut
            onActivated: {
                print("PlacesMap reload activated")
                map.createPlacesMap()
            }
            onActivatedAmbiguously: activated();
        }
        //        PlacesMap {
        //            id: placesMap
        //        }


    }

    PullPane {
        id: placeInfoPane

        Connections {
            target: map.placesMap
            function onPlaceSelected(modelItem) {
                placeInfoPane.modelItem = modelItem
            }
        }
    }

    RouteModel {
        id: routeModel

        autoUpdate: true
        query: routeQuery
        plugin: mapWindow.plugin
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
    }
    RouteQuery {
        id: routeQuery
    }

}
