pragma Singleton
import QtQuick 2.0
import QtLocation 5.15

Plugin {
    name: "mapbox"

    property string token: "sk.eyJ1IjoibS1rZXJyIiwiYSI6ImNrbGgxanhxaDEzcWUybnFwMTBkcW8xMGkifQ.dw1csFMpo1bOvxNAvLxrmg"

    PluginParameter {
        name: "mapbox.access_token"
        value: token
    }
}
