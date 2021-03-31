pragma Singleton

import QtQuick 2.15
import QtPositioning 5.15
import com.mkerr.navi 1.0

Item {
    id: root

    readonly property var coordinate: nmeaLog.coordinate

    // WARNING: Development only
    NmeaLog {
        id: nmeaLog
        //        logFile: "://output.nmea.txt"
        logFile: "/Volumes/Sierra/Users/mdkerr/Programming/Projects/Navi/\
src/qml/resources/output.nmea.txt"

        Component.onCompleted: {
            startUpdates()
        }
    }
}
