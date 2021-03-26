import QtGraphicalEffects 1.15
import QtPositioning 5.15
import QtLocation 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import com.mkerr.navi 1.0
import AppUtil 1.0
import MapboxPlugin 1.0
import EsriSearchModel 1.0
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
    // from GPS: positionSource.position.coordinate

    Item {
        id: itemWindow
        anchors.centerIn: parent
        width: parent.height
        height: parent.width
        //        rotation: -90

        property var stateStack: [""]

        property bool following: true
        property bool night
        property color bgColor: night? "black" : "lightgrey"

        function previousState() {
            if (stateStack.length > 1) {
                stateStack.pop();
                state = stateStack[stateStack.length - 1];
            }
        }

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
                ScriptAction { script: searchBar.activate() }
            },
            Transition {
                from: "searchPage"
                to: ""
                AnchorAnimation { duration: 200 }
                NumberAnimation { target: searchPage;
                    property: "opacity"; duration: 150 }
                ScriptAction { script: searchBar.deactivate() }
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
            night: itemWindow.night
        }

        SearchBar {
            id: searchBar
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.75
            z: 2
            bgColor: itemWindow.bgColor

            Binding {
                target: EsriSearchModel
                property: "searchTerm"
                value: searchBar.text
            }
        }

        MainMapPage {
            id: mainMapPage
            anchors.fill: parent
            z: 0

            following: itemWindow.following
            night: itemWindow.night
            //            traffic: bottomBar.traffic
            //            night: bottomBar.night
        }
        // WARNING: Dev tool, remove zoomInfo on release
        Text {
            id: zoomInfo
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 100
//            anchors.centerIn: parent
            text: "zoom: " + Math.round(mainMapPage.map.zoomLevel * 100) / 100
            color: "black"
            font.pixelSize: 16
            font.bold: true
            opacity: 0.7
            z: 1
        }
    }
}
