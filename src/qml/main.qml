import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
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

    property bool following: true
    property bool night
    property color bgColor: night? "black" : "lightgrey"

    MainMapPage {
        id: mainMapPage

        following: applicationWindow.following
        night: applicationWindow.night
        bgColor: applicationWindow.bgColor

        Connections {
            target: stackView

            function onFitViewportToMapItems() {
                mainMapPage.map.fitViewportToMapItems()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // WARNING: rotate stackview -90 for mobile production, remove anchors.fill
        //        anchors.centerIn: parent
        //        width: parent.height
        //        height: parent.width
        //        rotation: -90

        signal fitViewportToMapItems()

        function unwind() {
            mainMapPage.state = ""
            mainMapPage.previousState = ""
            pop(null)
        }

        initialItem: mainMapPage
        //        pushEnter: {}
        pushExit: Transition {}

        Connections {
            target: EsriSearchModel

            function onSelectPlace() {
                // WARNING: replace with qrc: for production
                stackView.push("pages/PlaceInfoPage.qml")
            }
        }
    }
}
