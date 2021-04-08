/**

  Were going to make the main direcctions two Rows, first, current directions,
  second, upcoming directions.
  Both will have a MouseArea that makes a ListView visible when pressed,
  Which contains every direction in the route.

  The current direction in the Listview will be highlighted at the top of the
  page. The directions will be scrollable with the completed directions greyed
  out.

  Even better, the ListView will contain a toggle `property bool open`
  When not open, the first two row states will be visible, and interactive false.

  When open, the second row is invisible and the remaining directions appear

  **/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import QtPositioning 5.15
import QtLocation 5.15
import EsriRouteModel 1.0
import Logic 1.0
import "../../components"

Item {
    id: root

    property int currentDirectionIndex: 1

    anchors.fill: parent

    visible: false

    Connections {
        id: rootConnections

        target: root

        function onCurrentDirectionIndexChanged () {
            headerRectLabel.updateText();
            nextInstructionRectLabel.updateText();
        }
    }

    Connections {
        target: Logic

        function onNavigate () {
            root.visible = true
             headerRectLabel.updateText()
             nextInstructionRectLabel.updateText()
        }

        function onEndNavigation () {
            visible = false
        }
    }

    Rectangle {
        id: headerRect

        height: parent.height * 0.2
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        color: "black"

        Label {
            id: headerRectLabel
            anchors.centerIn: parent
            color: "white"
            text: ""

            font {
                bold: true
                family: "Arial"
            }

            function updateText() {
                let segment = root.currentDirectionIndex ?
                        EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex]
                      : null
                if (segment) {
                    if (segment.maneuver.valid) {
                        headerRectLabel.text = "In " + Math.round(segment.distance) + " meters, "
                                + segment.maneuver.instructionText;
                    } else {
                        root.currentDirectionIndex++
                        print("maneuver invalid, headerRect increased currentDirectionIndex. Now:", root.currentDirectionIndex)
                    }
                } else {headerRectLabel.text = "Segment Invalid";}
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }
    }

    Rectangle {
        id: nextInstructionRect

        property alias text: nextInstructionRectLabel.text

        height: headerRect.height / 3
        width: listView.width
        anchors {
            top: headerRect.bottom
            left: parent.left
            right: parent.right
        }

        color: "grey"
        visible: !listView.open

        Label {
            id: nextInstructionRectLabel

            anchors.centerIn: parent
            color: "black"
            text: ""

            font {
                bold: true
                family: "Arial"
            }

            function updateText() {
                let segment = root.currentDirectionIndex ?
                        EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex + 1]
                      : null
                if (segment) {
                    if (segment.maneuver.valid) {
                        nextInstructionRect.visible = !listView.open
                        nextInstructionRectLabel.text = "In " + Math.round(segment.distance) + " meters, "
                                + segment.maneuver.instructionText;
                    } else {
                        nextInstructionRect.visible = false
                    }
                } else {nextInstructionRectLabel.text = "Segment Invalid";}
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }
    }

    ListView {
        id: listView

        property bool open: false

        anchors {
            top: headerRect.bottom
            bottom: parent.bottom
            left: parent.left
            right:parent.right
        }

        interactive: false

        model: ListModel {
            id: directionsListModel
            //            ListElement {prop: "Static element"}
            //            ListElement {prop: "Static element"}
        }

        onOpenChanged: {
            if (open && EsriRouteModel.status === RouteModel.Ready) {
                let segs = EsriRouteModel.routeModel.get(0).segments
                directionsListModel.clear()
                for (var i=0; i < segs.length; i++) {
                    directionsListModel.append({segment: segs[i]});
                }
                interactive = true
            } else {
                for (let i=directionsListModel.count - 1; i >= 0 ; i--) {
                    directionsListModel.remove(i, 1);
                }
                interactive = false
            }
        }

        add: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000 }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { properties: "x,y"; to: 0; duration: 1000 }
            }
        }

        removeDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000 }
        }

        delegate: Rectangle {
            id: delegateRect

            property int staticIndex
            property bool hasManeuver: segment.maneuver && segment.maneuver.valid

            width: listView.width
            height: visible? headerRect.height / 2 : 0

            color: staticIndex % 2 ? "steelblue" : "lightsteelblue"
            enabled: staticIndex > root.currentDirectionIndex

            Label {

                anchors.centerIn: parent

                text: {
                    if (hasManeuver) {
                        "in " + Math.round(segment.distance) + " meters, "
                                + segment.maneuver.instructionText
                    }
                    else "";
                }
            }

            Component.onCompleted: {
                // index = -1 occurs when the element's remove animation runs,
                // causing bugs. Assign staticIndex = index when component completes
                staticIndex = index
                // We want the element to be visible only if it has a maneuver and
                // isn't the first or last turn instruction. listView.count
                // changes upon removal, so visible cannot be a binding.
                visible = (hasManeuver && 0 < staticIndex
                           && staticIndex < listView.count - 1)
            }
        }
    }
}
