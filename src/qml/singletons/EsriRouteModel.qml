pragma Singleton

import QtQuick 2.15
import QtLocation 5.15
import Logic 1.0

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

    query: RouteQuery {
        id: routeQuery
        numberAlternativeRoutes: 3
        // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#routeOptimizations-prop
        routeOptimizations : RouteQuery.FastestRoute // default
        // https://doc.qt.io/qt-5/qml-qtlocation-routequery.html#travelModes-prop
        travelModes : routeQuery.CarTravel // default

        Connections {
            target: Logic

            function onAddWaypoint ( waypoint ) {
            }

            function onGetDirections () {
                let currentWaypoints = routeQuery.waypointObjects()
                if (currentWaypoints.length === 0) {
                    print("Error, no destination")
                }
                else {
                    // add current coordinate as waypoint
                    routeQuery.waypoints.unshift()
                }
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
