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

    // WARNING: return to widescreen for production
//    width: 1024
//    height: 768
    width: 1024
    height: 1024
    visible: true
    //    visibility: ApplicationWindow.FullScreen

    //     WARNING: Dev environment only, not meant for production
    property string mapboxToken: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"
    property var plugin: MapboxPlugin {token: mapboxToken}
    // from GPS: positionSource.position.coordinate
    property var currentCoordinate: nmeaLog.coordinate
    NmeaLog {
        id: nmeaLog
        logFile: "://output.nmea.txt"

        Component.onCompleted: {
            startUpdates()
        }
    }

    MapboxSearchModel{
        id: searchModel
        searchTerm: searchBar.text
        plugin: root.plugin

        searchLocation: currentCoordinate
    }

    Item {
        id: itemWindow
        anchors.centerIn: parent
        width: parent.height
        height: parent.width
//        rotation: -90

        property var stateStack: [""]

        property bool following: true
        property bool night
        property color bgColor: night? "black" : "grey"

        states: [
            State {
                name: ""
                PropertyChanges {
                    target: searchPage
                    visible: false
                    opacity: 0
                }
                AnchorChanges {
                    target: searchPage
                    anchors.bottom: itemWindow.top
                    anchors.top: itemWindow.top
                    anchors.left: itemWindow.left
                    anchors.right: itemWindow.right
                }
                PropertyChanges {
                    target: itemWindow
                    focus: true
                }
            },
            State {
                name: "searchPage"
                PropertyChanges {
                    target: searchPage
                    visible: true
                    opacity: 1
                }
                AnchorChanges {
                    target: searchPage;
                    anchors.bottom: itemWindow.bottom
                    anchors.top: itemWindow.top
                    anchors.left: itemWindow.left
                    anchors.right: itemWindow.right
                }
            }
        ]

        transitions: [
            Transition {
                from: ""
                to: "searchPage"
                AnchorAnimation { duration: 200 }
                NumberAnimation { target: searchPage;
                    property: "opacity"; duration: 150 }
            },
            Transition {
                from: "searchPage"
                to: ""
                AnchorAnimation { duration: 200 }
                NumberAnimation { target: searchPage;
                    property: "opacity"; duration: 150 }
            }
        ]

        state: ""
        onStateChanged: {
            if (state !== stateStack[stateStack.length - 1])
                stateStack.push(state);
        }

        SearchPage {
            id: searchPage
            visible: false
            z: 1

            anchors.bottom: itemWindow.top
            anchors.top: itemWindow.top
            anchors.left: itemWindow.left
            anchors.right: itemWindow.right

            bgColor: itemWindow.bgColor
            model: searchModel
        }

        SearchBar {
            id: searchBar
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.75
            z: 2
            bgColor: itemWindow.bgColor
            plugin: root.plugin
            currentCoordinate: root.currentCoordinate
            stateStack: itemWindow.stateStack

            input.onActiveFocusChanged: {
                if (input.activeFocus) {
                    itemWindow.state = "searchPage";
                }
            }
        }

        MapWindow {
            id: mapWindow
            anchors.fill: parent
            z: 0

            plugin: root.plugin
            following: itemWindow.following
            currentCoordinate: root.currentCoordinate
            night: itemWindow.night
            //            traffic: bottomBar.traffic
            //            night: bottomBar.night
        }
    }
}
