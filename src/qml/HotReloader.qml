import QtQuick 2.15

Item {
    id: reloader
    anchors.fill: parent

    property string source
    property bool ready: false

    property alias loader: _loader
    property alias item: _loader.item

    signal reload()
    onReload: load()

    function load() {
        _loader.source = ""
        $QmlEngine.clearCache();
        _loader.source = reloader.source
        print("Source Component " + reloader.source + " Updated")
    }

    Loader {
        id: _loader

        anchors.fill: parent
        Component.onCompleted: source = reloader.source

        onLoaded: reloader.ready = true
    }

    Shortcut {
        sequence: "F5"
        context: Qt.ApplicationShortcut
        onActivated: {
            print("Reload activated")
            reloader.reload();
        }
        onActivatedAmbiguously: activated();
    }
}
