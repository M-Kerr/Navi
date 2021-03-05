import QtQuick 2.0
import QtLocation 5.15

Plugin {
    name: "mapbox"

    property string token

    PluginParameter {
        name: "mapbox.access_token"
        value: token
    }
}
