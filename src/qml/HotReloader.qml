import QtQuick 2.15

Item {
    id: root
    anchors.fill: parent

    property string source
    property bool ready: false

    property alias loader: _loader
    property alias item: _loader.item

    Loader {
        id: _loader

        function reload() {
            source = ""
            $QmlEngine.clearCache();
            source = root.source
            print("Source Component " + root.source + " Updated")
        }

        anchors.fill: parent
        Component.onCompleted: source = root.source

        onLoaded: root.ready = true
    }

    Shortcut {
        sequence: "F5"
        context: Qt.ApplicationShortcut
        onActivated: {
            print("Reload activated")
            _loader.reload();
        }
        onActivatedAmbiguously: activated();
    }
}
