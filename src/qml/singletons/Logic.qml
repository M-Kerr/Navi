pragma Singleton

import QtQuick 2.15
import QtLocation 5.15

Item {
    id: root

    // Route
    signal addWaypoint ( var coordinate )
    signal getDirections ()
    function addWaypointAndGetDirections ( coordinate ) {
        addWaypoint ( coordinate )
        getDirections ()
    }

    // EsriRouteModel
    signal tripStateUpdated()

    // Map
    signal fitViewportToPlacesMapView ()
    signal fitViewportToMapItems ( var items )
    signal navigate ()
    signal endNavigation ()
    signal selectPlace ( var modelItem )
    onSelectPlace: {
        // WARNING: replace with qrc: for production
        pushStackView("pages/PlaceInfoPage.qml",
                      {
                          "place": modelItem.place,
                          "placeDistance": modelItem.distance
                      })
    }

    function backToPlacesMap () {
        fitViewportToPlacesMapView()
        popStackView()
    }

    // StackView
    signal pushStackView ( string page, var properties )
    signal popStackView ()
    signal unwindStackView ()
}
