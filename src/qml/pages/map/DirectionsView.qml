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
import QtPositioning 5.15
import QtLocation 5.15
import EsriRouteModel 1.0

ListView {
    id: listView

    property bool open: false

    height: parent.height / 4
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    highlightFollowsCurrentItem: true
    interactive: false
    spacing: 10
    model: EsriRouteModel.status === RouteModel.Ready ?
               EsriRouteModel.get(0).segments : null
    visible: model ? true : false

    header: Label { text: "HEADER TEXT!"; font.bold: true; color: "blue";}
    delegate: Row {
        width: listView.width
        spacing: 10
        property bool hasManeuver : modelData.maneuver && modelData.maneuver.valid
        visible: hasManeuver
        Text { text: (1 + index) + "." }
        Text { text: hasManeuver ? modelData.maneuver.instructionText : "" }
        // RouteSegment
        Text {
            text: "Segment distance " + modelData.distance + " meters, " + modelData.path.length + " points."
        }
        // RouteManeuver
        Text {
            text: "Distance till next maneuver: " + modelData.maneuver.distanceToNextInstruction
                  + " meters, estimated time: " + modelData.maneuver.timeToNextInstruction + " seconds."
        }
    }

    footer: Label { text: "FOOTER TEXT!"; font.bold: true }
}
