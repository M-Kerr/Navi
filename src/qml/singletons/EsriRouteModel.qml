pragma Singleton

import QtQuick 2.15
import QtLocation 5.15
import Logic 1.0
import GPS 1.0

RouteModel {
    id: root

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

        Connections {
            target: Logic

            function onAddWaypoint ( waypoint ) {
            }

            function onGetDirections () {

// WARNING DELETE THIS TEST****************************************************
                EsriRouteModel.query.addWaypoint(GPS.coordinate.atDistanceAndAzimuth(2000, 45))
// **************TODO delete test above*************************************************

                // Push current coordinate to the front of the waypoints list
                let wpts = routeQuery.waypoints
                routeQuery.clearWaypoints()
                routeQuery.addWaypoint(GPS.coordinate)
                for (let i=0; i < wpts.length; i++) {
                    routeQuery.addWaypoint(wpts[i])
                }

                root.update()
            }
        }






















        // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#waypoints-prop
        //        waypoints : list<coordinate>
        //        void addWaypoint(coordinate)
        //        void clearWaypoints()
        //        void removeWaypoint(coordinate)
        // This differs as it holds the waypoints represented as Waypoint objects, instead of coordinates. Read-only
        //        list<Waypoint> waypointObjects()


        // For future departure times. the T is literal, ss.zzz can be omitted,
        // The Z is a time-zone offset (e.g., -5), zzz is milliseconds
        //        departureTime : "YYYY-MM-DDThh:mm:ss.zzzZ"

        // Areas the route must not cross
        //        excludedAreas : list<georectangle>

        // Read-only, these can be set using MapParameter {}
        //        extraParameters : VariantMap

        // List of features that will be considered when planning the route
        // Traffic, tolls, highways, etc.
        // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#featureTypes-prop
        //        featureTypes : QList<FeatureType>
        // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#setFeatureWeight-method
        //        void setFeatureWeight(FeatureType feature, FeatureWeight weight)
        //        void resetFeatureWeights()



        //        Some plugins might allow or require specific parameters to operate.
        //        In order to specify these plugin-specific parameters, MapParameter
        //        elements can be nested inside a RouteQuery.
    }
}
