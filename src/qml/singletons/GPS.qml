pragma Singleton

import QtQuick 2.15
import QtPositioning 5.15
import EsriRouteModel 1.0

// WARNING remove below imports, CheapRuler, and NMEAlog for production
import com.mapbox.cheap_ruler 1.0
import com.mkerr.navi 1.0 //NMEAlog
import QtLocation 5.15

Item {
    id: root

    readonly property var coordinate: ruler.currentPosition
    property alias ruler: ruler

    CheapRuler {
        id: ruler

        // property real currentDistance === total distance traveled in millimeters
        // weeeird
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
        // for demonstration purposes only with the CheapRuler vehicle.
        // For a smoother user experience with actual vehicle tracking,
        // more variables should be accounted for, e.g., vehicle speed and
        // travel time to next segment.
        onCurrentDistanceChanged: {

            // TLDR: when <= 100 feet from end of segment, present next
            // instruction.
            // Continually adds the next segment's distance into
            // _sumSegmentsDistance when the current segment is completed.
            // When the difference between total distance traveled
            // (currentDistance) and _sumSegmentsDistance is <= 100 ft,
            // nextTurnInstructionIndex is incremented to the next segment
            // and the function repeats (the next segment is added to
            // _sumSegmentDistance).

            // 1 meter = 3.28084 feet
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
            // Initialize _sumSegmentsDistance with the first segment's distance
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
