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
import QtQuick.Layouts 1.15
import QtPositioning 5.15
import QtLocation 5.15
import EsriRouteModel 1.0
import Logic 1.0
import "../../components"

Item {
    id: root

    property int currentDirectionIndex: 1

    anchors.fill: parent

    Connections {
        id: rootConnections

        target: root

        function onCurrentDirectionIndexChanged () {
            headerRect.updateText();
            nextInstructionRect.updateText();
        }
    }

    Connections {
        target: Logic

        function onNavigate () {
            headerRect.updateText()
            nextInstructionRect.updateText()
        }

        function onEndNavigation () {
            directionsListModel.clear()
            listView.open = false
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

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 8

            Label {
                id: headerRectLabel

                Layout.alignment: Qt.AlignHCenter
                color: "white"
                text: ""

                font {
                    bold: true
                    family: "Arial"
                }
            }

            Label {
                id: headerRectDistanceLabel

                Layout.alignment: Qt.AlignHCenter
                visible: text
                color: "white"

                font {
                    family: "Arial"
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }

        function updateText() {
            let segment = root.currentDirectionIndex ?
                    EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex]
                  : null
            if (segment) {
                if (segment.maneuver.valid) {
                    headerRectLabel.text = segment.maneuver.instructionText
                    headerRectDistanceLabel.text = "Travel "
                            + Math.round(segment.distance) + " meters"
                } else {
                    root.currentDirectionIndex++
                    print("maneuver invalid, headerRect increased currentDirectionIndex. Index is now:", root.currentDirectionIndex)
                }
            } else {
                headerRectLabel.text = "Segment Invalid"
                headerRectDistanceLabel.text = ""
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
        visible: !listView.open && text !== ""

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 8

            Label {
                id: nextInstructionRectLabel

                Layout.alignment: Qt.AlignHCenter
                color: "black"
                text: ""

                font {
                    bold: true
                    family: "Arial"
                }
            }

            Label {
                id: nextInstructionRectDistanceLabel

                Layout.alignment: Qt.AlignHCenter
                visible: text
                color: "black"

                font {
                    family: "Arial"
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }

        function updateText() {
            let segment = root.currentDirectionIndex ?
                    EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex + 1]
                  : null
            if (segment) {
                if (segment.maneuver.valid) {
                    nextInstructionRectLabel.text = segment.maneuver.instructionText
                    nextInstructionRectDistanceLabel.text = "Travel "
                            + Math.round(segment.distance) + " meters"
                }
            } else {
                nextInstructionRectLabel.text = ""
                nextInstructionRectDistanceLabel.text = ""
            }
        }
    }

    ListView {
        id: listView

        property bool open: false
        property real _maxHeight: parent.height - headerRect.height

        height: contentHeight < _maxHeight ? contentHeight: _maxHeight

        anchors {
            top: headerRect.bottom
            left: parent.left
            right:parent.right
        }

        clip: true
        boundsMovement: Flickable.StopAtBounds

        model: ListModel {
            id: directionsListModel
        }

        onOpenChanged: {
            if (open && EsriRouteModel.status === RouteModel.Ready) {
                let segs = EsriRouteModel.routeModel.get(0).segments
                directionsListModel.clear()
                for (var i=0; i < segs.length; i++) {
                    directionsListModel.append({segment: segs[i]});
                }
                //                interactive = true
            } else {
                for (let i=directionsListModel.count - 1; i >= 0 ; i--) {
                    directionsListModel.remove(i, 1);
                }
                //                interactive = false
            }
        }

        add: Transition {
            NumberAnimation { property: "y"; duration: 1000 }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "y"; to: 0; duration: 1000 }
            }
        }

        removeDisplaced: Transition {
            NumberAnimation { property: "y"; duration: 1000 }
        }

        delegate: Rectangle {
            id: delegateRect

            property int staticIndex
            property bool hasManeuver: segment.maneuver && segment.maneuver.valid

            width: listView.width
            height: !visible? 0: headerRect.height / 2

            color: staticIndex % 2 ? "steelblue" : "lightsteelblue"
            enabled: staticIndex > root.currentDirectionIndex

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                Label {
                    id: instructionLabel

                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        if (hasManeuver) {
                            segment.maneuver.instructionText
                        }
                        else "";
                    }
                }

                Label {
                    id: instructionDistanceLabel

                    Layout.alignment: Qt.AlignHCenter
                    visible: text

                    text: {
                        if (hasManeuver) {
                            "Travel " + Math.round(segment.distance) + " meters"
                        }
                        else "";
                    }
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
