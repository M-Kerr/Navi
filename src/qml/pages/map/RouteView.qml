import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import EsriRouteModel 1.0
import Logic 1.0

//MapItemView {
//    id: root

// Note, EsriRouteModel.get(0) returns the first Route,
// Ultimately i should simply connect to EsriRouteModel to show All routes,
// Finally once the route is selected, I'll likely use a MapPolyLine
// and draw the individual segments of the Route, popping them off as the
// vehicle completes the segment.
//    model: EsriRouteModel.status === RouteModel.Ready ?
//               EsriRouteModel.get(0) : null

//    delegate: MapRoute {
//        route: routeData
MapRoute {
    route: EsriRouteModel.status === RouteModel.Ready ?
               EsriRouteModel.get(0) : null
    line.color: "blue"
    line.width: map.zoomLevel - 5
    smooth: true
    opacity: 0.8
}
//}

// Commented code below is the MapboxGL example using their cheapruler QML object
//
//        MapItemView {
//            model: routeModel

//            delegate: MapRoute {
//                route: routeData
//                line.color: "#ec0f73"
//                line.width: map.zoomLevel - 5
//                opacity: (index == 0) ? 1.0 : 0.3

//                onRouteChanged: {
//                    ruler.path = routeData.path;
//                    ruler.currentDistance = 0;

//                    currentDistanceAnimation.stop();
//                    currentDistanceAnimation.to = ruler.distance;
//                    currentDistanceAnimation.start();
//                }
//            }
//        }

//        MapQuickItem {
//            zoomLevel: map.zoomLevel

//            sourceItem: Image {
//                id: carMarker
//                source: "qrc:///car-marker.png"
//            }

//            coordinate: ruler.currentPosition
//            anchorPoint.x: carMarker.width / 2
//            anchorPoint.y: carMarker.height / 2
//        }

//        CheapRuler {
//            id: ruler

//            PropertyAnimation on currentDistance {
//                id: currentDistanceAnimation

//                duration: ruler.distance / mapWindow.carSpeed * 60 * 60 * 1000
//                alwaysRunToEnd: false
//            }

//            onCurrentDistanceChanged: {
//                var total = 0;
//                var i = 0;

//                // XXX: Use car speed in meters to pre-warn the turn instruction
//                while (total - mapWindow.carSpeed < ruler.currentDistance * 1000 && i < routeModel.get(0).segments.length)
//                    total += routeModel.get(0).segments[i++].maneuver.distanceToNextInstruction;

//                turnInstructions.text = routeModel.get(0).segments[i - 1].maneuver.instructionText;
//            }
//        }
//    }
