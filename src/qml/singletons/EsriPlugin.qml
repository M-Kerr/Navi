pragma Singleton

import QtQuick 2.0
import QtLocation 5.15

Plugin {
    id: root

    property string token: "AAPK5a729938a3c643eeb6984520e4ecbc49ZG7051qjj5QXeqVIs2dyho8ClWXlW3dzMieuYi6v3eavSC8aY3qyYMyBEItKRH6w"

    name: "esri"

    // If no locale parameter is supplied, plugin will request system locale,
    // which gives us inconsistent units to do math upon.
    // Junk locale parameter forces esri plugin to use default settings:
    // metric system, english.
    locales: "_"

    PluginParameter {
        name: "esri.token"
        value: root.token
    }
}
