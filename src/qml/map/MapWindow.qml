import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import com.mkerr.navi 1.0

Item {
    id: mapWindow

    property bool following
    property bool traffic
    property bool night

    states: [
        State {
            name: ""
            PropertyChanges { target: map; tilt: 0; bearing: 0; zoomLevel: map.zoomLevel }
        },
        State {
            name: "following"
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

    // TODO: uncomment this image
    Image {
        anchors.fill: parent
        //            anchors.left: parent.left
        //            anchors.right: parent.right
        z: 2

        source: "qrc:edge-gradient.png"
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
        anchors.top: parent.top
        anchors.margins: 20
        z: 3
        visible: !mapWindow.following
        source: "qrc:car-focus.png"

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
                //                value: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
                value: "pk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGNta2I4YzBubXIydW1ka2Y3bTRrcTMifQ.hj6C1wqwLdHi3_S6JHLCEA"
            }
            PluginParameter {
                // Renders route lines underneath labels
                name: "mapboxgl.mapping.items.insert_before"
                value: "road-label-small"
            }
            PluginParameter {
                name: "mapboxgl.mapping.additional_style_urls"
                //                value: "mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft,mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft,mapbox://styles/m-kerr/cklqr3b7z6lq317og47js6g0j/draft"
                value: "mapbox://styles/m-kerr/cklo1x8c226o018mvgfvhxj6c/draft"
                //                value: "mapbox://styles/mapbox/navigation-guidance-day-v4,mapbox://styles/mapbox/navigation-guidance-night-v4,mapbox://styles/mapbox/navigation-preview-day-v4,mapbox://styles/mapbox/navigation-preview-night-v4"
                // TODO delete these two copies above - temp for viewing purposes only
                //                    + "mapbox://styles/mapbox/navigation-guidance-day-v4,"
                //                    + "mapbox://styles/mapbox/navigation-guidance-night-v4,"
                //                    + "mapbox://styles/mapbox/navigation-preview-day-v4,"
                //                    + "mapbox://styles/mapbox/navigation-preview-night-v4"
            }
        }

        //        activeMapType: {
        //            var style;

        //            if (mapWindow.following) {
        //                style = night ? supportedMapTypes[1] : supportedMapTypes[0];
        //            } else {
        //                style = night ? supportedMapTypes[3] : supportedMapTypes[2];
        //            }

        //            return style;
        //        }

        // WARNING: Dev environment only, not meant for production
        center: mapWindow.following ? nmeaLog.coordinate : map.center;
        //                        positionSource.position.coordinate : map.center;

        zoomLevel: 12.25
        minimumZoomLevel: 0
        maximumZoomLevel: 20
        tilt: 60

        copyrightsVisible: false

        // NOTE: the "traffic-*" layers are for viewing traffic data. They should
        // belong to the single road network component, Traffic property.
//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-major-link-"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }

//        DynamicParameter {
//            type: "layout"

//            property var layer: "traffic-bridge-road-motorway-trunk-case-navigation"
//            property var visibility: mapWindow.traffic ? "visible" : "none"
//        }










        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-trunk-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-tunnel-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-tunnel-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk-tunnel-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-tunnel"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service-tunnel"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary-tunnel"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary-tunnel"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk-tunnel"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-trunk-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-trunk-bg-low"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-bg-low"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-trunk-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-bridge-bg"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-bridge-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk-bridge-dark-casing"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-links-bridge"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-street-service-bridge"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-secondary-tertiary-bridge"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-primary-bridge"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        //        DynamicParameter {
        //            type: "layout"

        //            property var layer: "traffic-motorway-trunk-bridge"
        //            property var visibility: mapWindow.traffic ? "visible" : "none"
        //        }

        // TODO: Delete this real-time paint and assign the color within the map studio
        DynamicParameter {
            type: "paint"
            property var layer: "building-extrusion"
            property var fillExtrusionColor: "#00617f"
            property var fillExtrusionOpacity: .6
            property var fillExtrusionHeight: { return { type: "identity", property: "height" } }
            property var fillExtrusionBase: { return { type: "identity", property: "min_height" } }
        }

        //        DynamicParameter {
        //            type: "layer"

        //            property var name: "3d-buildings"
        //            property var source: "composite"
        //            property var sourceLayer: "building"
        //            property var layerType: "fill-extrusion"
        //            property var minzoom: 15.0
        //        }

        //        DynamicParameter {
        //            type: "filter"

        //            property var layer: "3d-buildings"
        //            property var filter: [ "==", "extrude", "true" ]
        //        }

        //        DynamicParameter {
        //            type: "paint"

        //            property var layer: "3d-buildings"
        //            property var fillExtrusionColor: "#00617f"
        //            property var fillExtrusionOpacity: .6
        //            property var fillExtrusionHeight: { return { type: "identity", property: "height" } }
        //            property var fillExtrusionBase: { return { type: "identity", property: "min_height" } }
        //        }

        MouseArea {
            anchors.fill: parent

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
                source: "qrc:///current-location.png"
            }

            zoomLevel: map.zoomLevel
            coordinate: nmeaLog.coordinate //positionSource.position.coordinate
            anchorPoint.x: carMarker.width / 2
            anchorPoint.y: carMarker.height / 2
        }
    }

    // WARNING: Dev environment only, not meant for production
    // Substitute NmeaLog with PositionSource for live GPS
    NmeaLog {
        id: nmeaLog

        logFile: "://output.nmea.txt"

        Component.onCompleted: {
            startUpdates()
        }
    }

    RouteModel {
        id: routeModel

        autoUpdate: true
        query: routeQuery
        plugin: Plugin {
            name: "mapbox"

            PluginParameter {
                name: "mapbox.access_token"
                //     WARNING: Dev environment only, not meant for production
                value: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
            }
        }

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
