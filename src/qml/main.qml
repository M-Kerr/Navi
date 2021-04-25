import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import Logic 1.0
import "pages/map"

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
        }

        background: Rectangle {
            height: stackView.height
            width: stackView.width
            color: "darkgrey"
        }
    }
}
