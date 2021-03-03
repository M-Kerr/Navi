import QtGraphicalEffects 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.0
import "map"

ApplicationWindow {
    id: root

    width: 1024
    height: 768
    visible: true
    //    visibility: ApplicationWindow.FullScreen

    property bool following: true
    property string mapboxToken: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
    property var plugin: Plugin {
        name: "mapbox"

        PluginParameter {
            name: "mapbox.access_token"
            //     WARNING: Dev environment only, not meant for production
            value: mapboxToken
        }
    }

    Item {
        anchors.centerIn: parent
        width: parent.height
        height: parent.width
//        rotation: -90

        MapWindow {
            anchors.fill: parent
            z: 0
            plugin: root.plugin
            following: root.following
//            traffic: bottomBar.traffic
//            night: bottomBar.night
        }
    }
}
