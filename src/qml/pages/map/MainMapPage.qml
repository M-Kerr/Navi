import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import MapboxPlugin 1.0
import EsriSearchModel 1.0
import Logic 1.0
import GPS 1.0
import "../../components/SoftUI"
import "../../components"
import "../../animations"
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

    Item {
        id: searchBar

        property alias input: softRecessedSearchBar.input
        property string text: input.text

        z: 2
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

        Rectangle {
            id: backRect
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: parent.height
            width:  0
            radius: width
            color: root.bgColor
            clip: true
            enabled: false
            opacity: 0.0

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
        }

        SoftRecessedSearchBar {
            id: softRecessedSearchBar

            anchors.left: backRect.right
            anchors.leftMargin: 15
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

//            color:

            onInputActiveFocusChanged: {
                if (inputActiveFocus) {
                    mainMapPage.state = "searchPage";
                }
            }

            onAccepted: {
                if (text)
                {
                    //TODO center-fit map on all markers
                    map.fitViewportToMapItems()
                    mainMapPage.state = ""
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

    DirectionsView {
        id: directionsView
        z: 1
        visible: false
    }

    Button {
        id: endNavigationButton

        width: implicitWidth + 80
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: root.top
            margins: 20
        }

        z: 2
        visible: false
        text: "End Navigation"

        onClicked: {
            Logic.endNavigation()
            visible = false
        }
    }

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
