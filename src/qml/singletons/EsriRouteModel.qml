pragma Singleton

import QtQuick 2.15
import QtLocation 5.15
import Logic 1.0
import GPS 1.0

Item {
    id: root

    property alias routeModel: routeModel
    property alias status: routeModel.status

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

        function onEndNavigation () {
            routeQuery.clearWaypoints()
            routeModel.reset()
        }
    }

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

        // NOTE Debugging status updates. delete for release
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
}
