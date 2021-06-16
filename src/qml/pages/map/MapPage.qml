import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQml 2.15
import MapboxPlugin 1.0
//import WasmLocationPlugin 1.0
import EsriSearchModel 1.0
import EsriRouteModel 1.0
import Logic 1.0
import GPS 1.0
import AppUtil 1.0
import "qrc:/SoftUI"
import "qrc:/components"
import "qrc:/animations"
import "qrc:/pages"

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
            color: Qt.lighter(AppUtil.color.background, 1.50)
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

            Image {
                id: backImage

                anchors {
                    fill: parent
                    margins: 11
                }

                visible: false
                source: "qrc:/resources/arrow.png"
                rotation: -90
            }

            // Color the back arrow
            ColorOverlay {

                anchors.fill: source

                source: backImage
                color: AppUtil.color.fontSecondary
                rotation: -90
            }

            MouseArea {
                id: backRectMouseArea
                anchors.fill: parent
                onClicked: {
                    mainMapPage.state = ""
                }
            }

            Component.onCompleted: {
                color.a = 0.70
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

            iconColor: Qt.darker(AppUtil.color.fontSecondary, 1.25)
//            iconColor: AppUtil.color.fontSecondary
            color: "transparent"
            input.placeholderTextColor: AppUtil.color.fontSecondary
            input.color: AppUtil.color.fontPrimary
            input.selectionColor: AppUtil.color.foreground
//            input.selectionColor: AppUtil.color.fontSelect
            input.font: AppUtil.bodyFont
            clearButton.height: background.height * 0.50
            clearButton.color: Qt.lighter(AppUtil.color.background, 1.65)
            clearButton.topShadow.visible: false
            clearButton.topShadow.color: AppUtil.color.backgroundLightShadow
            clearButton.bottomShadow.color: AppUtil.color.backgroundDarkShadow
            clearButtonImage.visible: false
            clearButton.text: "x"
            clearButton.font: AppUtil.bodyFont
            clearButton.label.color: Qt.darker(AppUtil.color.fontSecondary, 1.5)
            clearButton.label.bottomPadding: 2.5

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
                color: Qt.lighter(AppUtil.color.background, 1.50)

                Component.onCompleted: {
                    color.a = 0.70
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

//        plugin: WasmLocationPlugin
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

        copyrightsVisible: true

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
            zoomLevel: root.state === "navigating" ? 0 : map.zoomLevel
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
                height: 30
                width: 30
                source: "qrc:/resources/locationMarker.png"
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
            map.zoomLevel = 17.5
        }

        PlacesMapView {
            id: placesMapView
        }

        RouteView {
            id: routeView
        }
        // WARNING: dev tool above and below, delete and replace with above
        // View components
//        property var placesMapView: null
//        property var routeView: null
        // instantiate impl and assign directionsView as parent. When
        // directionsView visibility changes, it'll change the visibility
        // of its child impl.
//        property var directionsViewImpl: null

        function createViews () {
//            if (placesMapView) {
//                map.removeMapItemView(placesMapView)
//                placesMapView.destroy()
//            }
//            if (routeView) {
//                map.removeMapItemView(routeView)
//                routeView.destroy()
//            }
//            if (directionsViewImpl) {
//                directionsViewImpl.destroy()
//            }

//            placesMapView = null
//            routeView = null
//            directionsViewImpl = null

            $QmlEngine.clearCache();

//            var comp = Qt.createComponent("PlacesMapView.qml")
//            placesMapView = comp.createObject(map, {})
//            map.addMapItemView(placesMapView)

//            comp = Qt.createComponent("RouteView.qml")
//            routeView = comp.createObject(map, {})
//            map.addMapItemView(routeView)

//            comp = Qt.createComponent("DirectionsViewImpl.qml")
//            directionsViewImpl = comp.createObject(directionsView, {})
        }

        Component.onCompleted: {
            map.createViews()
        }
    }

    Image {
        id: edgeGradient

        height: parent.height + 50
        width: parent.width
        y: -50

        source: "qrc:/resources/edge-gradient.png"
        opacity: 0.35
        visible: root.following
    }

    Rectangle {
        id: cameraFocusImageRect

        z: 1
        height: 30
        width: 30
        y: parent.height - anchors.margins - height
           - (tripPullPane.visible * tripPullPane.height)

        anchors {
            left: parent.left
            margins: 10
        }

        color: Qt.lighter(AppUtil.color.background, 1.45)
        radius: width / 8

        scale: cameraFocusMouseArea.pressed ? 0.85 : 1.0

        visible: {
            (root.StackView.status === StackView.Active) ? !root.following
                                                         : false
        }

        SequentialAnimation {
                id: opacityOffAnimation

                alwaysRunToEnd: false
            PropertyAction {
                target: opacityBinding
                property: "when"
                value: false
            }
            NumberAnimation {
                target: cameraFocusImageRect
                property: "opacity"; to: 0; duration: 200
            }
        }

        // Binds the opacity to 'y' position.
        SequentialAnimation {
            id: opacityOnAnimation

            alwaysRunToEnd: false

            NumberAnimation {
                target: cameraFocusImageRect
                property: "opacity"
                to: Math.min(
                        Math.pow(cameraFocusImageRect.y
                                 / (root.height
                                    - cameraFocusImageRect.anchors.margins
                                    - cameraFocusImageRect.height
                                    - tripPullPane.minHeight
                                    ),
                                 20),
                        1.0)
                duration: 150
            }

            PropertyAction {
                target: opacityBinding
                property: "when"
                value: true
            }
        }

        Binding {
            id: opacityBinding

            target: cameraFocusImageRect
            property: "opacity"
            value: Math.min(
                       Math.pow(cameraFocusImageRect.y
                                / (root.height
                                   - cameraFocusImageRect.anchors.margins
                                   - cameraFocusImageRect.height
                                   - tripPullPane.minHeight
                                   ),
                                20),
                       1.0)
            when: false
            restoreMode: Binding.RestoreBindingOrValue
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
            NumberAnimation { duration: 35 }
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

            anchors.fill: parent
            visible: false

            source: "qrc:/resources/focus.png"

        }

        ColorOverlay {
            id: imageColorOverlay
            source: cameraFocusImage

            anchors.fill: source
            color: Qt.lighter(AppUtil.color.accent, 1.25)
        }
    }

    // NOTE: this would probably be more maintainable if we used
    // states
    GlassPullPane {
        id: tripPullPane

        property real rowHeight: 40
        property real rowMargins: (minHeight / 2) - (rowHeight / 2)

        anchors.bottomMargin: -5

        z: 1
        radius: width / 40
        visible: false
        minHeight: 75
        source: map
        blurRadius: 60
        color: AppUtil.color.foreground

        RowLayout {
            id: shortDetailsRow

            implicitHeight: tripPullPane.rowHeight
            anchors {
                top: tripPullPane.top
                left: tripPullPane.left
                margins: tripPullPane.rowMargins
            }

            spacing: 30

            Item {
                id: arrivalLabelGroup

                implicitHeight: parent.height
                implicitWidth: childrenRect.width

                Label {
                    id: arrivalTime

                    anchors {
                        bottom: parent.verticalCenter
                        margins: 2.5
                    }

                    color: AppUtil.color.fontPrimary
                    font: AppUtil.headerFont
                }

                Label {
                    id: arrivalLabel

                    anchors {
                        top: parent.verticalCenter
                        margins: 2.5
                    }

                    text: "arrival"
                    color: AppUtil.color.fontSecondary
                    font: AppUtil.subHeaderFont
                }
            }

            Item {
                id: timeLabelGroup

                implicitHeight: parent.height
                implicitWidth: childrenRect.width

                Label {
                    id: timeRemaining

                    anchors {
                        bottom: parent.verticalCenter
                        margins: 2.5
                    }

                    color: AppUtil.color.fontPrimary
                    font: AppUtil.headerFont
                }

                Label {
                    id: timeLabel

                    anchors {
                        top: parent.verticalCenter
                        margins: 2.5
                    }

                    color: AppUtil.color.fontSecondary
                    font: AppUtil.subHeaderFont
                }
            }

            Item {
                id: distanceLabelGroup

                implicitHeight: parent.height
                implicitWidth: childrenRect.width

                Label {
                    id: distanceRemaining

                    anchors {
                        bottom: parent.verticalCenter
                        margins: 2.5
                    }

                    color: AppUtil.color.fontPrimary
                    font: AppUtil.headerFont
                }

                Label {
                    id: distanceLabel

                    anchors {
                        top: parent.verticalCenter
                        margins: 2.5
                    }

                    color: AppUtil.color.fontSecondary
                    font: AppUtil.subHeaderFont
                }
            }
        }

        Button {
            id: resumeButton

            property alias openAnimation: openAnimation
            property alias closeAnimation: closeAnimation

            implicitHeight: tripPullPane.rowHeight
            implicitWidth: {
                tripPullPane.width / 2 - tripPullPane.rowMargins
                        - 10 // spacing
            }
            anchors {
                top: tripPullPane.top
                left: tripPullPane.left
                margins: tripPullPane.rowMargins
            }

            visible: false
            opacity: 0

            SequentialAnimation {
                id: openAnimation

                alwaysRunToEnd: false

                PropertyAction {
                    target: shortDetailsRow
                    property: "visible"
                    value: false
                }

                PauseAnimation { duration: 50 }

                PropertyAction {
                    target: resumeButton
                    property: "visible"
                    value: true
                }

                NumberAnimation {
                    target: resumeButton
                    property: "opacity"
                    to: 1
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            SequentialAnimation {
                id: closeAnimation

                alwaysRunToEnd: false

                NumberAnimation {
                    target: resumeButton
                    property: "opacity"
                    to: 0
                    duration: 250
                    easing.type: Easing.InQuad
                }

                PropertyAction {
                    target: resumeButton
                    property: "visible"
                    value: false
                }

                // Resets button to visually unpressed state
                ScriptAction {
                    script: resumeButton.canceled()
                }

                PauseAnimation { duration: 50 }

                PropertyAction {
                    target: shortDetailsRow
                    property: "visible"
                    value: true
                }
            }

            onClicked: {
                closeAnimation.start()
                endNavigationButton.shrinkAnimation.start()
            }

            onPressed: {
                background.shadow.visible = false
                background.color.a /= 1.2
                background.blurRadius /= 1.2
                resumeButton.scale = 0.99
            }

            onCanceled: {
                background.shadow.visible = true
                background.color.a *= 1.2
                background.blurRadius *= 1.2
                resumeButton.scale = 1.0
            }

            background: SoftGlassBox {
                source: tripPullPane.source
                blurRadius: tripPullPane.blurRadius * 2
                color {
                    hsvHue: 0.0
                    hsvSaturation: 0.0
                    hsvValue: 0.80
                    a: Math.min(tripPullPane.color.a * 2, 1.0)
                }
                radius: height / 6
                width: resumeButton.width + 1
                height: resumeButton.height + 1
                shadow {
                    visible: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 2
                    color: Qt.darker(resumeButton.background.color, 3.0)
                }
            }

            Label {
                id: resumeLabel

                anchors.centerIn: parent

                text: "Resume"
                color: AppUtil.color.fontSecondary
                font: AppUtil.headerFont
                Component.onCompleted: {
                    font.pixelSize = 16
                }
            }
        }

        Button {
            id: endNavigationButton

            property alias shrinkAnimation: shrinkAnimation
            property alias expandAnimation: expandAnimation
            property bool _expanded: false

            implicitHeight: tripPullPane.rowHeight
            implicitWidth: endLabel.width + 40
            anchors {
                top: tripPullPane.top
                right: tripPullPane.right
                margins: tripPullPane.rowMargins
            }

            ParallelAnimation {
                id: expandAnimation

                property int duration: 250

                NumberAnimation {
                    target: endNavigationButton
                    property: "implicitWidth"
                    to: {
                        tripPullPane.width / 2 - tripPullPane.rowMargins
                                - 10 // spacing
                    }
                    duration: expandAnimation.duration
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: endLabel.anchors
                    property: "horizontalCenterOffset"
                    to: {
                        (endLabel.width
                         - endLabel.width
                         - routeLabel.width
                         - routeLabel.anchors.leftMargin)
                                / 2
                    }
                    duration: expandAnimation.duration
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: routeLabel
                    property: "visible"
                    value: true
                }
                NumberAnimation {
                    target: routeLabel
                    property: "opacity"
                    to: 1
                    duration: expandAnimation.duration
                    easing.type: Easing.InQuad
                }
                PropertyAction {
                    target: endNavigationButton
                    property: "_expanded"
                    value: true
                }
            }

            SequentialAnimation {
                id: shrinkAnimation

                property int duration: 250

                ParallelAnimation {
                    NumberAnimation {
                        target: endNavigationButton
                        property: "implicitWidth"
                        to: endLabel.width + 40
                        duration: shrinkAnimation.duration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: endLabel.anchors
                        property: "horizontalCenterOffset"
                        to: 0
                        duration: shrinkAnimation.duration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: routeLabel
                        property: "opacity"
                        to: 0
                        duration: shrinkAnimation.duration
                        easing.type: Easing.InQuad
                    }
                    PropertyAction {
                        target: endNavigationButton
                        property: "_expanded"
                        value: false
                    }
                }

                PropertyAction {
                    target: routeLabel
                    property: "visible"
                    value: false
                }
            }

            onClicked: {
                if (_expanded) {
                    Logic.endNavigation()
                    resumeButton.closeAnimation.start()
                    endNavigationButton.shrinkAnimation.start()
                } else {
                    resumeButton.openAnimation.start()
                    expandAnimation.start()
                }
            }

            onDownChanged: {
                if (down) {
                    background.shadow.visible = false
                    background.color.a /= 1.2
                    background.blurRadius /= 1.2
                    endNavigationButton.scale = 0.99
                } else {
                    background.shadow.visible = true
                    background.color.a *= 1.2
                    background.blurRadius *= 1.2
                    endNavigationButton.scale = 1.0
                }
            }

            background: SoftGlassBox {
                source: tripPullPane.source
                blurRadius: tripPullPane.blurRadius * 2
                color: AppUtil.color.accent
                radius: height / 6
                shadow {
                    visible: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 2
                    color: AppUtil.color.accentDarkShadow
                }

                Component.onCompleted: {
                    color.a = Math.min(tripPullPane.color.a * 2, 1.0)
                }
            }

            Item {
                anchors.fill: parent
                clip: true

                Label {
                    id: endLabel

                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: "End"
                    color: AppUtil.color.foreground
                    font: AppUtil.headerFont
                    Component.onCompleted: {
                        font.pixelSize = 16
                    }
                }

                Label {
                    id: routeLabel

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: endLabel.right
                        leftMargin: 4
                    }

                    text: "Route"
                    visible: false
                    opacity: 0
                    color: AppUtil.color.foreground
                    font: AppUtil.headerFont
                    Component.onCompleted: {
                        font.pixelSize = 16
                    }
                }
            }
        }

        Component.onCompleted: {
            color.a = 0.925
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
            root.following = true
            root.state = "navigating"
        }

        function onEndNavigation () {
            root.state = ""
        }

        function onTripStateUpdated () {
            // EsriRouteModel.tripTimeRemaining: int;seconds
            let hours = Math.floor(EsriRouteModel.tripTimeRemaining / 3600)
            let minutes = Math.floor((EsriRouteModel.tripTimeRemaining % 3600)
                                     / 60);
            if (hours) {
                timeLabel.text = "hrs"
                timeRemaining.text = hours
                if (hours < 14) timeRemaining.text += ":" + minutes;
            } else {
                timeLabel.text = "min"
                if (!minutes) timeRemaining.text = "< 1";
                else timeRemaining.text = minutes;
            }

            // EsriRouteModel.tripArrivalTime: Date
            arrivalTime.text = EsriRouteModel.tripArrivalTime.toLocaleTimeString(Locale.ShortFormat);

            // EsriRouteModel.tripDistanceRemaining: int;meters
            // Convert to feet
            let distanceFeet = Math.round(EsriRouteModel.tripDistanceRemaining
                                          *  3.281)

            if (distanceFeet > 1000) {
                // Convert to miles
                distanceRemaining.text = Math.round((distanceFeet / 5280) * 100)
                        / 100;
                distanceLabel.text = "mi"
            } else {
                distanceRemaining.text = distanceFeet
                distanceLabel.text = "ft"
            }
        }
    }
}
