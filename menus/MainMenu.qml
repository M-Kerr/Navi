import QtQuick 2.15
import QtQuick.Controls 2.15
// TODO: remove all quick controls 1
import QtQuick.Controls 1.4 as QQC1
import QtLocation 5.15

MenuBar {
    property variant  providerMenu: providerMenu
    property variant  mapTypeMenu: mapTypeMenu
    property variant  toolsMenu: toolsMenu
    property alias isFollowMe: toolsMenu.isFollowMe

    signal selectProvider(string providerName)
    signal selectMapType(variant mapType)
    signal selectTool(string tool);
    signal toggleMapState(string state)

    Menu {
        id: providerMenu
        title: qsTr("Provider")

        function createMenu(plugins)
        {
            for (var i = 0; i < plugins.length; i++) {
                createProviderMenuItem(plugins[i]);
            }
        }

        function createProviderMenuItem(provider)
        {
            var item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + provider + '";'
                                               + ' checkable: true}',
                                               providerMenu)
            addItem(item);
            item.triggered.connect(function(){selectProvider(provider)})
        }
    }

    Menu {
        id: mapTypeMenu
        title: qsTr("MapType")

        function createMenu(map)
        {
            // Clear the menu
            for (var i = count - 1; i >= 0; i--)
            {
                removeItem(itemAt(i))
            }
            for (i = 0; i<map.supportedMapTypes.length; i++) {
                createMapTypeMenuItem(map.supportedMapTypes[i]).checked =
                        (map.activeMapType === map.supportedMapTypes[i]);
            }
        }

        function createMapTypeMenuItem(mapType)
        {
            // TODO: delete print statement
            print("creating mapTypeMenuItem: ", mapType.name)
            var name = mapType.name
            if (name.startsWith("mapbox://styles/mapbox/")) {
                name = name.slice(23)
            }

            var item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + name + '";'
                                               + ' checkable: true}',
                                               mapTypeMenu)
            addItem(item);
            item.triggered.connect(function(){selectMapType(mapType)})
            return item;
        }
    }

    QQC1.Menu {
        id: toolsMenu
        property bool isFollowMe: false;
        title: qsTr("Tools")

        function createMenu(map)
        {
            if (map.plugin.supportsGeocoding(Plugin.ReverseGeocodingFeature)) {
                addItem(qsTr("Reverse geocode")).triggered.connect(function(){selectTool("RevGeocode")})
            }
            if (map.plugin.supportsGeocoding()) {
                addItem(qsTr("Geocode")).triggered.connect(function(){selectTool("Geocode")})
            }
            if (map.plugin.supportsRouting()) {
                addItem(qsTr("Route with coordinates")).triggered.connect(function(){selectTool("CoordinateRoute")})
                addItem(qsTr("Route with address")).triggered.connect(function(){selectTool("AddressRoute")})
            }

            var item = addItem("")
            item.text = Qt.binding(function() { return isFollowMe ? qsTr("Stop following") : qsTr("Follow me")})
            item.triggered.connect(function() {toggleMapState("FollowMe")})

            addItem(qsTr("Language")).triggered.connect(function(){selectTool("Language")})
            addItem(qsTr("Prefetch Map Data")).triggered.connect(function(){selectTool("Prefetch")})
            addItem(qsTr("Clear Map Data")).triggered.connect(function(){selectTool("Clear")})
        }
    }
}
