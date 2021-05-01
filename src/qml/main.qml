import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import EsriRouteModel 1.0
import Logic 1.0
import AppUtil 1.0
import "pages/map"
import "components"
import "components/SoftUI"

ApplicationWindow {
    id: applicationWindow

    //320 x 568
    width: 320
    height: 568
//    width: 1024
//    height: 1024
    visible: true
    // WARNING: return to widescreen for production
    //    width: 1024
    //    height: 768
    //    visibility: ApplicationWindow.FullScreen

    // WARNING: Dev tool, remove zoomInfo on release
    Text {
        id: zoomInfo

        visible: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 100
        text: "zoom: " + Math.round(mainMapPage.map.zoomLevel * 100) / 100
        color: "black"
        font.pixelSize: 16
        font.bold: true
        opacity: 0.7
        z: 1
    }

    property bool night
    property color bgColor: night? "black" : "lightgrey"

    MapPage {
        id: mainMapPage

        night: applicationWindow.night
        bgColor: applicationWindow.bgColor
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // WARNING: rotate stackview -90 for mobile production, remove anchors.fill
        //        anchors.centerIn: parent
        //        width: parent.height
        //        height: parent.width
        //        rotation: -90

        initialItem: mainMapPage
        pushEnter: Transition {
            OpacityAnimator { from: 0; to: 1; duration: 350 }
        }

        popExit: Transition {
            OpacityAnimator { from: 1; to: 0; duration: 150 }
            ScaleAnimator { from: 1; to: 10; duration: 250 }
        }
        // Empty transitions allow map to stay visible in the stack
        pushExit: Transition {}
        popEnter: Transition {
            OpacityAnimator { from: 0; to: 1; duration: 400 }
            //            ScaleAnimator { from: 0; to: 1; duration: 100 }
            //            YAnimator {
            //             from: (stackView.mirrored ? -1 : 1) * stackView.height
            //             to: 0
            //             duration: 600
            //             easing.type: Easing.OutCubic
            //            }
        }

        background: Rectangle {
            height: stackView.height
            width: stackView.width
            color: "darkgrey"
        }
    }

    // NOTE: this would probably be more maintainable if we
    // states
    GlassPullPane {
        id: tripPullPane

        property real rowHeight: 40
        property real rowMargins: (minHeight / 2) - (rowHeight / 2)

        visible: false
        minHeight: 75
        source: stackView
        blurRadius: 40
        color {
            hsvHue: 0
            hsvSaturation: 0
            hsvValue: 0.90
            a: 0.70
        }


        // margin 10
        // height 60
        // spacing 20 //probably doesn't matter

        //        RowLayout {
        //            id: topRow

        //            height: 60
        //            anchors {
        //                top: parent.top
        //                left: parent.left
        //                right: parent.right
        //                margins: 10
        //            }

        //            spacing: 20

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
                    tripPullPane.visible = false
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
                width: endNavigationButton.width + 1
                height: endNavigationButton.height + 1
                shadow {
                    visible: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 2
                    color: Qt.darker(endNavigationButton.background.color,
                                     3.0)
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
                    color: AppUtil.color.fontSecondary
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
                    color: AppUtil.color.fontSecondary
                    font: AppUtil.headerFont
                    Component.onCompleted: {
                        font.pixelSize = 16
                    }
                }
            }
        }
    }

    Connections {
        target: Logic

        function onPushStackView ( page, properties ) {
            stackView.push(page, properties)
        }

        function onPopStackView () {
            stackView.pop()
        }

        function onUnwindStackView () {
            stackView.pop(null)
        }

        function onGetDirections () {
            Logic.unwindStackView()
        }

        function onNavigate () {
            tripPullPane.visible = true
        }

        function onEndNavigation () {
            tripPullPane.visible = false
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
            let distanceFeet = EsriRouteModel.tripDistanceRemaining *  3.281
            if (distanceFeet > 1000) {
                // Convert to miles
                distanceRemaining.text =   Math.round((distanceFeet / 5280) * 100)
                        / 100;
                distanceLabel.text = "mi"
            } else {
                distanceRemaining.text = distanceFeet
                distanceLabel.text = "ft"
            }
        }
    }
}
