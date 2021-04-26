import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import Logic 1.0
import "pages/map"
import "components"
import "components/SoftUI"

ApplicationWindow {
    id: applicationWindow

    width: 1024
    height: 1024
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

    GlassPullPane {
        id: tripPullPane

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

        RowLayout {
            id: topRow

            height: 60
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }

            spacing: 20
            ColumnLayout {
                id: arrivalColumn

                Label {
                    id: arrivalTime
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "Temp."
                }

                Label {
                    id: arrivalLabel
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "arrival"
                }
            }

            ColumnLayout {
                id: timeRemainingColumn

                Label {
                    id: timeRemaining
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "Temp."
                }

                Label {
                    id: timeLabel
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "min"
                }
            }
            ColumnLayout {
                id: milesRemainingColumn

                Label {
                    id: milesRemaining
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "Temp."
                }

                Label {
                    id: milesLabel
                    ColumnLayout.alignment: Qt.AlignLeft
                    text: "mi"
                }
            }

            Item {
                id: topRowBuffer1

                RowLayout.fillWidth: true
            }

            Button {
                id: resumeButton

                implicitHeight: 40

                visible: false
                text: "Resume"

                onClicked: {
                    // NOTE: instead of calling endNavigation(), should check for
                    // navigating state and prompt user to end navigating to
                    // previous destination
                    Logic.endNavigation()
                    Logic.addWaypointAndGetDirections ( place.location.coordinate )
                }

                onDownChanged: {
                    if (down) {
                        background.shadow.visible = false
                        background.color.a /= 1.2
                        background.blurRadius /= 1.2
                        background.border.width = 0
                    } else {
                        background.shadow.visible = true
                        background.color.a *= 1.2
                        background.blurRadius *= 1.2
                        background.border.width = 1
                    }
                }

                background: SoftGlassBox {
                    source: mainMapPage
                    blurRadius: tripPullPane.blurRadius * 2
                    color {
                        hsvHue: 0.0
                        hsvSaturation: 0.0
                        hsvValue: 0.80
                        a: tripPullPane.glassOpacity * 2
                    }
                    radius: 0
                    width: resumeButton.width + 1
                    height: resumeButton.height + 1
                    border {
                        width: 1
                        color {
                            hsvHue: 0.0
                            hsvSaturation: 0.0
                            hsvValue: 0.90
                            a: 0.40
                        }
                    }
                    shadow {
                        visible: true
                        horizontalOffset: 0
                        verticalOffset: -0.3
                        radius: 14
                    }
                }
            }
            // End
            Button {
                id: endNavigationButton

                property bool _expanded: false

                implicitHeight: 40
                //                implicitWidth: endLabel.width + endButtonRow.margins

                RowLayout.fillWidth: false

                onClicked: {
                    if (_expanded) {
                        Logic.endNavigation()
                        tripPullPane.visible = false
                    } else {
                        // expand the button - call expandAnimation
                        //  - make Resume visible
                        //  - fade in "Route"
                        _expanded = true
                    }
                }

                onDownChanged: {
                    if (down) {
                        background.shadow.visible = false
                        background.color.a /= 1.2
                        background.blurRadius /= 1.2
                        background.border.width = 0
                    } else {
                        background.shadow.visible = true
                        background.color.a *= 1.2
                        background.blurRadius *= 1.2
                        background.border.width = 1
                    }
                }

                background: SoftGlassBox {
                    source: mainMapPage
                    blurRadius: tripPullPane.blurRadius * 2
                    color {
                        hsvHue: 0.0
                        hsvSaturation: 0.0
                        hsvValue: 0.80
                        a: tripPullPane.glassOpacity * 2
                    }
                    radius: height / 6
                    width: endNavigationButton.width + 1
                    height: endNavigationButton.height + 1
                    border {
                        width: 1
                        color {
                            hsvHue: 0.0
                            hsvSaturation: 0.0
                            hsvValue: 0.90
                            a: 0.40
                        }
                    }
                    shadow {
                        visible: true
                        horizontalOffset: 0
                        verticalOffset: -0.3
                        radius: 14
                    }
                }

                RowLayout {
                    id: endButtonRow

                    anchors {
                        centerIn: parent
                        margins: 10
                    }

                    spacing: 4

                    Label {
                        id: endLabel

                        text: "End"
                    }

                    Label {
                        id: routeLabel

                        visible: false
                        text: "Route"
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
    }
}






























