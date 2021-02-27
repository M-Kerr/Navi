import QtGraphicalEffects 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.0
import "map"

ApplicationWindow {
    id: root

    property bool following: true

    width: 1024
    height: 768
    visible: true
    //    visibility: ApplicationWindow.FullScreen

    Item {
        anchors.centerIn: parent
        width: parent.height
        height: parent.width
        //        rotation: -90

        MapWindow {
            anchors.fill: parent
            z: 0
            following: root.following
//            traffic: bottomBar.traffic
//            night: bottomBar.night
        }
    }
}
