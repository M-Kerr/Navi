import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtLocation 5.15
import QtPositioning 5.15
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import Logic 1.0
import GPS 1.0
import AppUtil 1.0
import "../../components/SoftUI"
import "../../components"
import "../../animations"
import ".."

Item {
    id: root

    property bool following: true
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

    MapPageStates { id: mapPageStates }
    states: mapPageStates.states
    transitions: mapPageStates.transitions
    state: ""
    onFollowingChanged: {
        if (following) map.center = currentCoordinate;
    }
    onCurrentCoordinateChanged: {
        if (following) {
            map.center = currentCoordinate
        }
    }

    Image {
        anchors.fill: parent
        z: 1

        //        source: "qrc:edge-gradient.png"
        source: "../../resources/edge-gradient.png"
        opacity: 0.7
        visible: root.following
    }

    Item {
        id: searchBar

        property alias input: softRecessedSearchBar.input
        property string text: input.text

        z: 3
        height: 35
        width: root.width * 0.75
        anchors {
            top: root.top
            topMargin: 40
            horizontalCenter: root.horizontalCenter
        }

        Binding {
            target: EsriSearchModel

            property: "searchTerm"
            value: searchBar.text
        }

        onEnabledChanged: {
            if (enabled) opacity = 1;
            else opacity = 0;
        }

        SoftGlassBox {
            id: backRect

            height: parent.height
            width:  0
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            source: map
            radius: width
            blurRadius: 30
            color: AppUtil.color.foreground
            enabled: false
            opacity: 0.0
            layer.enabled: true
            layer.effect: InnerShadow {
                radius: 6
                samples: 20
                verticalOffset: 0.75
                horizontalOffset: 0.75
                color: "#c8c8c8"
            }

            Label {
                anchors.centerIn: parent
                text: "≺"
                font.bold: true
                font.family: "Arial"
                color: root.night? "grey" : "black"
            }

            MouseArea {
                id: backRectMouseArea
                anchors.fill: parent
                onClicked: {
                    mainMapPage.state = ""
                }
            }

            Component.onCompleted: {
                color.a = 0.65
            }
        }

        SoftRecessedSearchBar {
            id: softRecessedSearchBar

            z: 1
            anchors {
                left: backRect.right
                leftMargin: 15
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            color: "transparent"
            input.placeholderTextColor: AppUtil.color.fontSecondary
            clearButton.topShadow.visible: false

            onInputActiveFocusChanged: {
                if (inputActiveFocus) {
                    mainMapPage.state = "searchPage";
                }
            }

            onAccepted: {
                if (text)
                {
                    map.fitViewportToMapItems()
                    mainMapPage.state = ""
                }
            }

            SoftGlassBox {
                id: searchBarGlassBox

                z: -1
                anchors.fill: parent.background

                source: map
                radius: parent.radius
                blurRadius: 50
                color: AppUtil.color.foreground

                Component.onCompleted: {
                    color.a = 0.20
                }
            }
        }

        Behavior on opacity { NumberAnimation {} }
        ActivateSearchBarAnimation { id: activateAnim }
        DeactivateSearchBarAnimation { id: deactivateAnim }

        function activate() { activateAnim.start() }
        function deactivate() { deactivateAnim.start() }
    }

    SearchPage {
        id: searchPage
        visible: false

        z: 2
        anchors {
            bottom: root.top
            top: root.top
            left: root.left
            right: root.right
        }

        bgColor: root.bgColor
        night: root.night
    }

    DirectionsView {
        id: directionsView
        z: 1
        visible: false
    }

    Map {
        id: map

        anchors.fill: parent

        MapStates { id: mapStates }
        states: mapStates.states
        transitions: mapStates.transitions
        state: root.following ? "following" : ""

        Connections {
            target: Logic

            function onFitViewportToMapItems( items ) {
                root.following = false
                map.fitViewportToMapItems( items )
            }

            function onSelectPlace( modelItem ) {
                root.following = false
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

        center: root.following ? root.currentCoordinate : map.center;

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
            if (previousLocation.coordinate === center || !root.following) {
                return;
            }

            bearingAnimation.to = previousLocation.coordinate.azimuthTo(center);
            bearingAnimation.start();

            previousLocation.coordinate = center;
        }

        MapQuickItem {
            id: carMarker

            // WARNING: carMarker's zoomLevel must be 0. When != 0, MapQuickItem's
            // rotation breaks. When MapQuickItem.zoomLevel !=0, it no longer
            // rotates on the sourceItem's axis but rather some window
            // coordinate axis. It may be possible to create a custom
            // transformOrigin when zoomLevel != 0 that identifies the
            // carMarker anchorPoint as the transformOrigin.
            coordinate: root.currentCoordinate
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2

            onCoordinateChanged: {
                if (following) {
                    carMarkerRotationAnimation.to = previousCarLocation.coordinate.azimuthTo(coordinate) - map.bearing
                    carMarkerRotationAnimation.start()
                } else {
                    carMarkerRotationAnimation.to = previousCarLocation.coordinate.azimuthTo(coordinate);
                    carMarkerRotationAnimation.start()
                }
                previousCarLocation.coordinate = coordinate
            }

            RotationAnimation {
                id: carMarkerRotationAnimation

                target: carMarker
                duration: 250
                alwaysRunToEnd: false
                direction: RotationAnimation.Shortest
            }

            Location {
                id: previousCarLocation

                coordinate: root.currentCoordinatee
            }

            sourceItem: Image {
                height: 40
                width: 40
                //                source: "qrc:../../resources/locationMarker.svg"
                source: "../../resources/locationMarker.svg"
            }
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

        //                    RouteView {
        //                        id: routeView
        //                    }
        // WARNING: dev tool, delete and replace with above View components
        property var placesMapView: null
        property var routeView: null
        property var directionsViewImpl: null

        function createViews () {
            if (placesMapView) {
                map.removeMapItemView(placesMapView)
                placesMapView.destroy()
            }
            if (routeView) {
                map.removeMapItemView(routeView)
                routeView.destroy()
            }
            if (directionsViewImpl) {
                directionsViewImpl.destroy()
            }

            placesMapView = null
            routeView = null
            directionsViewImpl = null

            $QmlEngine.clearCache();

            var comp = Qt.createComponent("PlacesMapView.qml")
            placesMapView = comp.createObject(map, {})
            map.addMapItemView(placesMapView)

            comp = Qt.createComponent("RouteView.qml")
            routeView = comp.createObject(map, {})
            map.addMapItemView(routeView)

            comp = Qt.createComponent("DirectionsViewImpl.qml")
            directionsViewImpl = comp.createObject(directionsView, {})
        }

        Component.onCompleted: {
            map.createViews()
        }
    }

    Rectangle {
        id: cameraFocusImageRect

        z: 1
        height: 60
        width: 60
        y: parent.height - (75 + 20 + height)
        anchors {
            left: parent.left
            margins: 20
        }

        color: AppUtil.color.foreground
        radius: width / 8
        opacity: 0
        scale: cameraFocusMouseArea.pressed ? 0.85 : 1.0

        visible: {
            (root.StackView.status === StackView.Active) ? !root.following
                                                         : false
        }

        NumberAnimation {
            id: opacityOffAnimation

            target: cameraFocusImageRect
            property: "opacity"; to: 0; duration: 200
            alwaysRunToEnd: false
        }
        NumberAnimation {
            id: opacityOnAnimation

            target: cameraFocusImageRect
            property: "opacity"; to: 1; duration: 200
            alwaysRunToEnd: false
        }

        onVisibleChanged: {
            if (visible) {
                opacityOffAnimation.stop()
                opacityOnAnimation.start()
            } else {
                opacityOnAnimation.stop()
                opacityOffAnimation.start()
            }
        }

        Behavior on scale {
            NumberAnimation {}
        }

        MouseArea {
            id: cameraFocusMouseArea
            anchors.fill: parent
            onClicked: {
                root.following = true
            }
        }

        Image {
            id: cameraFocusImage

            height: 50
            width: 50
            anchors.centerIn: parent
            // source: "qrc:resources/cameraFocus.svg"
            source: "../../resources/cameraFocus.svg"

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
            root.following = true
        }

        function onEndNavigation () {
            root.state = ""
        }
    }
}
