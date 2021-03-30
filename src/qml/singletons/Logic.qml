pragma Singleton

import QtQuick 2.15
import QtLocation 5.15

Item {
    id: root

    signal addWaypoint ( var coord )
    signal buildRouteQuery ()
    signal getRoutes ( RouteQuery query )
    signal fitViewportToMapItems( var items )
    signal fitViewportToPlacesMapView()

    Component {
        id: routeQuery
        RouteQuery {}
    }

    function createWaypoint ( coord: coordinate ) {
        // TODO: Ensure waypoint is not within a barrier
        addWaypoint(coord)
    }

    function addWaypointAndGetRoutes( coord: coordinate ) {
        createWaypoint ( coord )
        buildRouteQuery ()
        getRoutes ( query )
    }
}
