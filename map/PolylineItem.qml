import QtQuick 2.5
import QtLocation 5.6

// TODO: See if/how this component is used, and remove if not used

MapPolyline {

    line.color: "#46a2da"
    line.width: 4
    opacity: 0.25
    smooth: true

    function setGeometry(markers, index){
        for (var i = index; i<markers.length; i++){
            addCoordinate(markers[i].coordinate)
        }
    }
}
