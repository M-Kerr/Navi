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
    id: mainMapPage

    property bool following
    property bool traffic
    property bool night
    property color bgColor
    property string previousState: ""

    // WARNING map alias allows zoom level dev tool to read map. delete for release
    property alias map: map

    StackView.visible: true
    StackView.onActivating: {
        state = previousState
        searchBar.enabled = true
    }
    StackView.onDeactivating: searchBar.enabled = false

    MainMapPageStates{id: mainMapPageStates}
    states: mainMapPageStates.states
    transitions: mainMapPageStates.transitions
    state: ""

    Connections {
        target: Logic

        function onUnwindStackView() {
            mainMapPage.state = ""
            mainMapPage.previousState = ""
        }

        function onSelectPlace ( modelItem ) {
            mainMapPage.previousState = mainMapPage.state
            mainMapPage.state = ""
        }
    }

    SearchBar {
        id: searchBar
        z: 2

        width: parent.width * 0.75
        anchors {
            top: parent.top
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }

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
        anchors {
            bottom: parent.top
            top: parent.top
            left: parent.left
            right: parent.right
        }

        bgColor: parent.bgColor
        night: parent.night
    }

    Item {
        id: mapWindow

        property var currentCoordinate: GPS.coordinate

        anchors.fill: parent

        MainMapStates { id: mainMapStates }
        states: mainMapStates.states
        transitions: mainMapStates.transitions
        state: mainMapPage.following ? "following" : ""

        Image {
            anchors.fill: parent
            z: 2

            //        source: "qrc:edge-gradient.png"
            source: "../../resources/edge-gradient.png"
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


//        Image {
//            height: 80
//            width: 80
//            anchors.left: parent.left
//            anchors.bottom: parent.bottom
//            anchors.margins: 20
//            z: 3
//            visible: !mainMapPage.following
//            //        source: "qrc:car-focus.png"
//            source: "../../resources/car-focus.png"

//            MouseArea {
//                id: area
//                anchors.fill: parent
//                onClicked: {
//                    mainMapPage.following = true
//                }
//            }

//            scale: area.pressed ? 0.85 : 1.0

//            Behavior on scale {
//                NumberAnimation {}
//            }
//        }

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

            MapQuickItem {
                sourceItem: Image {
                    id: carMarker
                    //                source: "qrc:///current-location.png"
                    source: "../../resources/current-location.png"
                }

                zoomLevel: map.zoomLevel
                coordinate: mapWindow.currentCoordinate
                anchorPoint.x: carMarker.width / 2
                anchorPoint.y: carMarker.height / 2
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

            function centerView(itemCoordinate) {
                map.center = itemCoordinate
                map.zoomLevel = 18.5
            }

            //        PlacesMapView {
            //            id: placesMap
            //        }
            // WARNING: dev tool, delete and replace with PlacesMapView
            property var placesMap: null
            function createPlacesMapView () {
                if (placesMap) {
                    map.removeMapItemView(placesMap)
                    placesMap.destroy()
                }
                placesMap = null
                $QmlEngine.clearCache();
                var comp = Qt.createComponent("PlacesMapView.qml")
                placesMap = comp.createObject(map, {})
                map.addMapItemView(placesMap)
            }

            Component.onCompleted: {
                createPlacesMapView()
            }
        }
    }
}
