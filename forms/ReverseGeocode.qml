import QtQuick 2.5
import QtPositioning 5.5

//Reverse Geocode Dialog
ReverseGeocodeForm {
    property string title;
    property variant coordinate
    signal showPlace(variant coordinate)
    signal closeForm()

    goButton.onClicked: {
        var coordinate = QtPositioning.coordinate(parseFloat(latitude.text),
                                                          parseFloat(longitude.text));
        if (coordinate.isValid) {
            showPlace(coordinate)
        }
    }

    clearButton.onClicked: {
        latitude.text = ""
        longitude.text = ""
    }

    cancelButton.onClicked: {
        closeForm()
    }

    Component.onCompleted: {
        latitude.text = "" + coordinate.latitude
        longitude.text = "" + coordinate.longitude
        if (title.length != 0) {
            tabTitle.text = title;
        }
    }
}
