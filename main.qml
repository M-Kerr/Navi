import QtGraphicalEffects 1.0
import QtLocation 5.9
import QtPositioning 5.0
import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import "map"

ApplicationWindow {
    id: window

    property var navigating: true

    width: 1024
    height: 768
    visible: true
    visibility: ApplicationWindow.FullScreen

    Item {
        anchors.centerIn: parent
        width: parent.height
        height: parent.width
        rotation: -90

        MapWindow {
            anchors.fill: parent

            z: 0

//            traffic: bottomBar.traffic
//            night: bottomBar.night
        }
    }
}
