pragma Singleton

import QtQuick 2.15
import QtPositioning 5.15

// WARNING remove below imports, CheapRuler, and NMEAlog for production
import com.mapbox.cheap_ruler 1.0
import com.mkerr.navi 1.0
import QtLocation 5.15

Item {
    id: root

    readonly property var coordinate: ruler.currentPosition
    property alias ruler: ruler

    CheapRuler {
        id: ruler

        property real carSpeed: 95 //35
        property int nextTurnInstructionIndex: 1
        property var route
        property int _sumSegmentsDistance

        path: [QtPositioning.coordinate(34.049988197958406, -118.31766833213446)]

        PropertyAnimation on currentDistance {
            id: currentDistanceAnimation

            duration: ruler.distance / ruler.carSpeed * 60 * 60 * 1000
            alwaysRunToEnd: false
        }

        // WARNING: This is a simple algorithm to pre-warn turn instructions,
        // for demonstration purposes only with the CheapRuler vehicle. Do not
        // use in actual vehicle tracking.
        onCurrentDistanceChanged: {
            // when <= 100 feet from end of segment, present next instruction.
            if (_sumSegmentsDistance - (currentDistance * 1000 * 3.28084) <= 100 &&
                // Stop incrementing once we're at the final segment's instruction
                nextTurnInstructionIndex < route.segments.length - 1) {
                nextTurnInstructionIndex++;
                // Add the next segment's distance to the sum
                _sumSegmentsDistance += route.segments[nextTurnInstructionIndex].distance
            }
        }
    }

    Connections {
        target: Logic

        function onNavigate () {
            ruler.nextTurnInstructionIndex = 1
            ruler.route = EsriRouteModel.routeModel.get(0)
            ruler._sumSegmentsDistance = ruler.route.segments[ruler.nextTurnInstructionIndex].distance

            ruler.path = EsriRouteModel.routeModel.get(0).path
            ruler.currentDistance = 0;

            currentDistanceAnimation.stop();
            currentDistanceAnimation.to = ruler.distance;
            currentDistanceAnimation.start();
        }
    }

    NmeaLog {
        id: nmeaLog
        logFile: "/Volumes/Sierra/Users/mdkerr/Programming/Projects/Navi/\
src/qml/resources/output.nmea.txt"

        //        Component.onCompleted: {
        //            startUpdates()
        //        }
    }
}
