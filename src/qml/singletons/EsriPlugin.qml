pragma Singleton

import QtQuick 2.0
import QtLocation 5.15

Plugin {
    id: esriPlugin
    name: "esri"

    property string token: "AAPK5a729938a3c643eeb6984520e4ecbc49ZG7051qjj5QXeqVIs2dyho8ClWXlW3dzMieuYi6v3eavSC8aY3qyYMyBEItKRH6w"

    PluginParameter {
        name: "esri.token"
        value: esriPlugin.token
    }
}
