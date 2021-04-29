pragma Singleton

import QtQuick 2.15
import QtLocation 5.15
import Logic 1.0
import QtQml 2.15

Item {
    id: root

    property alias routeModel: routeModel
    property alias status: routeModel.status

    // Seconds
    property int tripTimeRemaining
    // Date
    property var tripArrivalTime
    // Meters
    property int tripDistanceRemaining

    property int _currentRouteSegment
    property var _routeSegments

    // NOT a total of distance remaining. Used in conjunction with
    // GPS.ruler.currentDistance to find the distance remaining in the current
    // segment, sums (increments) with the next segment's distance as the
    // segment is entered.
    // Meters
    property int _sumRemainingSegmentDistance

    RouteModel {
        id: routeModel

        plugin: EsriPlugin
        autoUpdate: false

        onErrorChanged: {
            print("RouteModel:")
            switch (error) {
                case RouteModel.NoError: print("No Error occurred"); break;
                case RouteModel.CommunicationError:
                print("An error occurred while communicating with the service provider."); break;
                case RouteModel.EngineNotSetError:
                print("he model's plugin property was not set or there is no routing manager associated with the plugin."); break;
                case RouteModel.MissingRequiredParameterError:
                print("A required parameter was not specified."); break;
                case RouteModel.ParseError:
                print("The response from the service provider was in an unrecognizable format."); break;
                case RouteModel.UnknownError:
                print("Unknown error."); break;
                case RouteModel.UnknownParameterError:
                print("The plugin did not recognize one of the parameters it was given"); break;
                case RouteModel.UnsupportedOptionError:
                print(" The requested operation is not supported by the routing provider. This may happen when the loaded engine does not support a particular type of routing request."); break;
            }
            print("errorString:", errorString);
        }

        // NOTE Debugging status updates. Log for release
        onStatusChanged: {
            switch (status) {
                case RouteModel.Null: print(" No route requests have been issued "
                                            +"or reset has been called."); break;
                case RouteModel.Ready: print(" Route request(s) have finished "
                                             +"successfully."); break;
                case RouteModel.Loading: print("Route request has been issued but "
                                               +"not yet finished"); break;
                case RouteModel.Error: print("Routing error has occurred, details "
                                             +" are in error and errorString"); break;
            }
        }

        query: RouteQuery {
            id: routeQuery
            numberAlternativeRoutes: 3
            // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#routeOptimizations-prop
            routeOptimizations : RouteQuery.FastestRoute // default
            // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#travelModes-prop
            travelModes : RouteQuery.CarTravel // default
        }
    }

    Timer {
        id: refreshTimer

        running: false
        interval: 5000
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateTripState()
    }

    function updateTripState () {

        let segment = root._routeSegments[root._currentRouteSegment]
        // real;Meters
        let remainingSegmentDistance =  _sumRemainingSegmentDistance
                                        - (GPS.ruler.currentDistance * 1000); // km -> m

        // Calculate tripTimeRemaining.
        // Subtracts the % of current segment already traveled from its
        // travel time, summing with the travel time of the remaining segments.
        // segment.distance: meters
        let percentSegRemaining = remainingSegmentDistance / segment.distance;
        let segmentTimeRemaining = Math.round(segment.travelTime
                                                 * percentSegRemaining);
        let sumTime = segmentTimeRemaining
        for (let i = _currentRouteSegment + 1; i < root._routeSegments.length; i++) {
            sumTime += root._routeSegments[i].travelTime
        }
        tripTimeRemaining = sumTime
        tripArrivalTime = new Date(Date.now() + (tripTimeRemaining * 1000))

        // Calculate tripDistanceRemaining
        // real;Meters
        let sumDistance = (remainingSegmentDistance > 0) ?
                remainingSegmentDistance : 0;
        for (let x = _currentRouteSegment + 1; x < _routeSegments.length; x++) {
            sumDistance += _routeSegments[x].distance
        }
        // Meters
        tripDistanceRemaining = Math.round(sumDistance)

        Logic.tripStateUpdated()
    }

    Connections {
        id: routeModelConnections

        target: routeModel
        enabled: false

        function onStatusChanged () {
            // WARNING: In a future update, Logic.navigate() should only be triggered
            // when the user selects a route to travel, not on a status change.
            if (status === RouteModel.Ready)
                Logic.navigate();
        }
    }

    Connections {
        id: logicConnections

        target: Logic

        function onAddWaypoint ( coordinate ) {
            routeQuery.addWaypoint ( coordinate )
        }

        function onGetDirections () {
            // Push device's current location to the front of the waypoints list
            let wpts = routeQuery.waypoints
            routeQuery.clearWaypoints()
            routeQuery.addWaypoint(GPS.coordinate)
            for (let i=0; i < wpts.length; i++) {
                routeQuery.addWaypoint(wpts[i])
            }

            routeModel.update()
            routeModelConnections.enabled = true
        }

        function onNavigate () {
            refreshTimer.start()
            root._routeSegments = routeModel.get(0).segments
            root._currentRouteSegment = 1
            root._sumRemainingSegmentDistance = root._routeSegments[_currentRouteSegment].distance
        }

        function onEndNavigation () {
            routeQuery.clearWaypoints()
            routeModel.reset()
            refreshTimer.stop()
        }
    }

    Connections {
        target: GPS.ruler

        // GPS.ruler.currentDistance is in kilometers, tracks trip distance traveled
        function onCurrentDistanceChanged () {

            // Meters
            let remainingSegmentDistance =      _sumRemainingSegmentDistance
                                                - (GPS.ruler.currentDistance
                                                   * 1000); // km -> m

            // Calculates route segment vehicle is currently traveling and
            // increments _sumRemainingSegmentDistance
            if (remainingSegmentDistance <= 0
                    && _currentRouteSegment < _routeSegments.length - 1) {
                _currentRouteSegment++
                _sumRemainingSegmentDistance += _routeSegments[_currentRouteSegment].distance
            }
        }
    }

    Connections {
        target: GPS.ruler.currentDistanceAnimation

        function onFinished () {
            Logic.endNavigation()
        }
    }
}
