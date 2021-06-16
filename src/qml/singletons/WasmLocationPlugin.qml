pragma Singleton

import QtQuick 2.0
import QtLocation 5.15

Plugin {
    id: root
    name: "osm"

    property string mapID: "thf-nighttransit"

    PluginParameter {
        name: "osm.mapping.host"
        value: "http://a.tile.thunderforest.com/"
    }
    PluginParameter {
        name: "osm.mapping.copyright"
        value: "<a href='http://www.thunderforest.com/'>Thunderforest</a>"
    }
}
