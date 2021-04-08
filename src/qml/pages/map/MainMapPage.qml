import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import Logic 1.0
import GPS 1.0
import "../../components"
import ".."

Item {
    id: root

    property bool following
    property bool traffic
    property bool night
    property color bgColor
    property string previousState: ""
    property var currentCoordinate: GPS.coordinate

    // WARNING map alias allows zoom level dev tool to read map. delete for release
    property alias map: map

    StackView.visible: true
    StackView.onActivating: {
        state = previousState
        searchBar.enabled = true
    }
    StackView.onDeactivating: searchBar.enabled = false

    MainMapStates { id: mainMapStates }
    states: mainMapStates.states
    transitions: mainMapStates.transitions
    state: root.following ? "following" : ""

    Image {
        anchors.fill: parent
        z: 1

        //        source: "qrc:edge-gradient.png"
        source: "../../resources/edge-gradient.png"
        opacity: 0.7
        visible: root.following
    }

    SearchBar {
        id: searchBar
        z: 2

        width: root.width * 0.75
        anchors {
            top: root.top
            topMargin: 40
            horizontalCenter: root.horizontalCenter
        }

        bgColor: root.bgColor

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
        anchors {
            bottom: root.top
            top: root.top
            left: root.left
            right: root.right
        }

        bgColor: root.bgColor
        night: root.night
    }

    // WARNING: delete this property when DirectionsView component is uncommented
    DirectionsView {
        id: directionsView
        z: 1
        visible: false
    }

    Button {
        id: endNavigationButton

        anchors {
            right: root.right
            bottom: root.bottom
            margins: 40
        }

        z: 2
        visible: false
        text: "End Navigation"

        onClicked: {
            Logic.endNavigation()
            visible = false
        }
    }

    //    CustomLabel {
    //        id: turnInstructions

    //        anchors.top: root.top
    //        anchors.horizontalCenter: root.horizontalCenter
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
        z: 2
        visible: !root.following
        //        source: "qrc:car-focus.png"
        source: "../../resources/car-focus.png"

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

        Connections {
            target: EsriSearchModel

        }

        Connections {
            target: Logic

            function onFitViewportToMapItems( items ) {
                map.fitViewportToMapItems( items )
            }

            function onSelectPlace( modelItem ) {
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
        center: root.following ? root.currentCoordinate : map.center;
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

        MapQuickItem {
            sourceItem: Image {
                id: carMarker
                //                source: "qrc:///current-location.png"
                source: "../../resources/current-location.png"
            }

            zoomLevel: map.zoomLevel
            coordinate: root.currentCoordinate
            anchorPoint.x: carMarker.width / 2
            anchorPoint.y: carMarker.height / 2
        }

        Shortcut {
            id: mapViewsReloader
            sequence: "F5"
            context: Qt.ApplicationShortcut
            onActivated: {
                print("MapViews reload activated")
                map.createViews()
            }
            onActivatedAmbiguously: activated();
        }

        function centerView(itemCoordinate) {
            map.center = itemCoordinate
            map.zoomLevel = 18.5
        }

        //        PlacesMapView {
        //            id: placesMap
        //        }

        //            RouteView {
        //                id: routeView
        //            }
        // WARNING: dev tool, delete and replace with View components
        // NOTE: directionsView is not a map view, resides outside of mapWindow
        property var placesMapView: null
        property var routeView: null
        //            property var directionsView: null

        function createViews () {
            if (placesMapView) {
                map.removeMapItemView(placesMapView)
                placesMapView.destroy()
            }
            if (routeView) {
                //                    map.removeMapItemView(routeView)
                map.removeMapItem(routeView)
                routeView.destroy()
            }
            //                if (directionsView) {
            //                    directionsView.destroy()
            //                }

            placesMapView = null
            routeView = null
            //                directionsView = null

            $QmlEngine.clearCache();

            var comp = Qt.createComponent("PlacesMapView.qml")
            placesMapView = comp.createObject(map, {})
            map.addMapItemView(placesMapView)

            comp = Qt.createComponent("RouteView.qml")
            routeView = comp.createObject(map, {})
            //                map.addMapItemView(routeView)
            map.addMapItem(routeView)

            //                comp = Qt.createComponent("DirectionsView.qml")
            //                directionsView = comp.createObject(root, {})
        }

        Component.onCompleted: {
            map.createViews()
        }
    }

    Connections {
        target: Logic

        function onUnwindStackView() {
            root.state = ""
            root.previousState = ""
        }

        function onSelectPlace ( modelItem ) {
            root.previousState = root.state
            root.state = ""
        }

        function onNavigate() {
            root.state = "navigating"
        }

        function onEndNavigation () {
            root.state = ""
        }
    }
}
