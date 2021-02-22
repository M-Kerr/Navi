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

    Component {
        id: menuItem

        MenuItem {
            checkable: true
        }
    }

    Menu {
        id: providerMenu
        title: qsTr("Provider")

        property variant currentSelection

        // plugins: array<string>
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
            item.triggered.connect(function(){
                if (providerMenu.currentSelection)
                        providerMenu.currentSelection.checked = false;
                item.checked = true
                providerMenu.currentSelection = item
                selectProvider(provider)
            })
            addItem(item);
        }
    }

    Menu {
        id: mapTypeMenu
        title: qsTr("MapType")

        property variant currentSelection

        function clear()
        {
            for (var i = count - 1; i >= 0; i--)
            {
                removeItem(itemAt(i))
            }
        }

        function createMapTypeMenuItem(mapType)
        {
            var name = mapType.name
            if (name.startsWith("mapbox://styles/mapbox/")) {
                name = name.slice(23)
            }
            var item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + name + '";'
                                               + ' checkable: true}',
                                               mapTypeMenu)
            item.triggered.connect(function(){
                mapTypeMenu.currentSelection.checked = false;
                item.checked = true
                mapTypeMenu.currentSelection = item
                selectMapType(mapType)
            })
            addItem(item);
            return item;
        }

        function createMenu(map)
        {
            clear()
            for (var i = 0; i < map.supportedMapTypes.length; i++) {
                var item = createMapTypeMenuItem(map.supportedMapTypes[i])
                if (map.activeMapType === map.supportedMapTypes[i]) {
                    item.checked = true
                    mapTypeMenu.currentSelection = item
                }
            }
        }
    }

    Menu {
        id: toolsMenu
        property bool isFollowMe: false;
        title: qsTr("Tools")

        function clear()
        {
            for (var i = count - 1; i >= 0; i--)
            {
                removeItem(itemAt(i))
            }
        }

        function createMenu(map)
        {
            clear()
            var item
            if (map.plugin.supportsGeocoding(Plugin.ReverseGeocodingFeature)) {
                item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + qsTr("Reverse Geocode") + '"}',
                                               toolsMenu)
                item.triggered.connect(function(){selectTool("RevGeocode")})
                addItem(item)
            }
            if (map.plugin.supportsGeocoding()) {
                item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + qsTr("Geocode") + '"}',
                                               toolsMenu)
                item.triggered.connect(function(){selectTool("Geocode")})
                addItem(item)
            }
            if (map.plugin.supportsRouting()) {
                item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + qsTr("Route with coordinates") + '"}',
                                               toolsMenu)
                item.triggered.connect(function(){selectTool("CoordinateRoute")})
                addItem(item)
                item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                               + ' MenuItem{ text: "'
                                               + qsTr("Route with address") + '"}',
                                               toolsMenu)
                item.triggered.connect(function(){selectTool("AddressRoute")})
                addItem(item)
            }

            item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                      + ' MenuItem{}',
                                      toolsMenu)
            item.triggered.connect(function(){toggleMapState("FollowMe")})
            item.text = Qt.binding(function() {
                return isFollowMe ? qsTr("Stop following") : qsTr("Follow me")})
            addItem(item)

            item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                      + ' MenuItem{ text: "'
                                      + qsTr("Language") + '"}',
                                      toolsMenu)
            item.triggered.connect(function(){selectTool("Language")})
            addItem(item)

            item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                      + ' MenuItem{ text: "'
                                      + qsTr("Prefetch Map Data") + '"}',
                                      toolsMenu)
            item.triggered.connect(function(){selectTool("Prefetch")})
            addItem(item)

            item = Qt.createQmlObject('import QtQuick.Controls 2.15;'
                                      + ' MenuItem{ text: "'
                                      + qsTr("Clear Map Data") + '"}',
                                      toolsMenu)
            item.triggered.connect(function(){selectTool("Clear")})
            addItem(item)
        }
    }
}









































