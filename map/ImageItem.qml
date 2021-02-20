import QtQuick 2.5;
import QtLocation 5.6

MapQuickItem {  //to be used inside MapComponent only
    id: imageItem

    MouseArea {
        anchors.fill: parent
        drag.target: parent
    }

    function setGeometry(markers, index) {
        coordinate.latitude = markers[index].coordinate.latitude
        coordinate.longitude = markers[index].coordinate.longitude
    }

    // TODO: Remove test image
    sourceItem: Image {
        id: testImage
        source: "../resources/icon.png"
        opacity: 0.7
    }
}
