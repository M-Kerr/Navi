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
