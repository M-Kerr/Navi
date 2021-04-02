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

    CheapRuler {
        id: ruler

        property real carSpeed: 35

        path: [QtPositioning.coordinate(34.049988197958406, -118.31766833213446)]

        PropertyAnimation on currentDistance {
            id: currentDistanceAnimation

            duration: ruler.distance / ruler.carSpeed * 60 * 60 * 1000
            alwaysRunToEnd: false
        }

        onCurrentDistanceChanged: {
            var total = 0;
            var i = 0;
            // XXX: Use car speed in meters to pre-warn the turn instruction
            // NOTE: use below as a hint for next turn instruction switch implementation
//            while (total - mapWindow.carSpeed < ruler.currentDistance * 1000
//                   && i < routeModel.get(0).segments.length)
//            total += routeModel.get(0).segments[i++].maneuver.distanceToNextInstruction;

//            turnInstructions.text = routeModel.get(0).segments[i - 1].maneuver.instructionText;
        }
    }

    Connections {
        target: EsriRouteModel

        function onStatusChanged () {
            if (EsriRouteModel.status === RouteModel.Ready) {
                ruler.path = EsriRouteModel.get(0).path
                ruler.currentDistance = 0;

                currentDistanceAnimation.stop();
                currentDistanceAnimation.to = ruler.distance;
                currentDistanceAnimation.start();
            }
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
