pragma Singleton

import QtQuick 2.15
import QtLocation 5.15

Item {
    id: root

    // Route
    signal addWaypoint ( var coordinate )
    signal buildRouteQuery ()
    signal getRoutes ( RouteQuery query )

    // Map
    signal fitViewportToPlacesMapView ()
    signal fitViewportToMapItems ( var items )

    // StackView
    signal pushStackView ( string page, var properties )
    signal popStackView ()
    signal unwindStackView ()

    signal selectPlace ( var modelItem )
    onSelectPlace: {
        // WARNING: replace with qrc: for production
        pushStackView("pages/PlaceInfoPage.qml",
                      {
                          "place": modelItem.place,
                          "placeDistance": modelItem.distance
                      })
    }



    Component {
        id: routeQuery
        RouteQuery {}
    }

    function backToPlacesMap () {
        fitViewportToPlacesMapView()
        popStackView()
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
