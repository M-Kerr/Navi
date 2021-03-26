import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import com.mkerr.navi 1.0
import "map"
import "components"

ApplicationWindow {
    id: root

    width: 1024
    height: 1024
    visible: true
    // WARNING: return to widescreen for production
    //    width: 1024
    //    height: 768
    //    visibility: ApplicationWindow.FullScreen
    // WARNING: rotate stackview -90 for mobile production
    //        rotation: -90
    // WARNING: Dev tool, remove zoomInfo on release
    property bool following: true
    property bool night
    property color bgColor: night? "black" : "lightgrey"

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

    MainMapPage {
        id: mainMapPage
        anchors.fill: parent
        z: 0

        following: root.following
        night: root.night
        // WARNING bgColor is deprecated
        bgColor: root.bgColor
    }
}
