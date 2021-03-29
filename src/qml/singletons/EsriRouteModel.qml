pragma Singleton

import QtQuick 2.15
import QtLocation 5.15

RouteModel {
    id: routeModel

    plugin: EsriPlugin
    autoUpdate: true
    measurementSystem:

}
