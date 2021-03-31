import QtQuick 2.15
import QtPositioning 5.15
import QtLocation 5.15
import EsriRouteModel 1.0

ListView {
    id: listview
    anchors.fill: parent
    spacing: 10
    model: EsriRouteModel.status === RouteModel.Ready ?
               EsriRouteModel.get(0).segments : null
    visible: model ? true : false
    delegate: Row {
        width: parent.width
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
}
