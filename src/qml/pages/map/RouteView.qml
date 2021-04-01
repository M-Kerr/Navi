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

// Commented code below is the MapboxGL example using their CheapRuler QML object
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

        // Set the CheapRuler's currentPosition to GPS position
//            coordinate: ruler.currentPosition
//        }

//        CheapRuler {
//            id: ruler

//            onCurrentDistanceChanged: {
//                var total = 0;
//                var i = 0;

/***************

 // XXX: Use car speed in meters to pre-warn the turn instruction

 while (
 // while the accumulated total - vehicle's speed is < Distance traveled
            total - mapWindow.carSpeed < ruler.currentDistance * 1000

                    // while i < the number of segments in the route
            && i < routeModel.get(0).segments.length)

            // total == the distance to the next instruction after each maneuver
     total += routeModel.get(0).segments[i++].maneuver.distanceToNextInstruction;

 turnInstructions.text = routeModel.get(0).segments[i - 1].maneuver.instructionText;

 *************/
//            }
//        }
//    }




/****************
  Figure out how CheapRuler.currentDistance works

  Figure out how the Pre-warn loop inside onCurrentDistanceChanged works.
    - The instructions for the next segment's maneuver is loaded according to
      some ratio between the vehicles speed and distance to next segment.

****************/

























































