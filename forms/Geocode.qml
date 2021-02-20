import QtQuick 2.5
import QtPositioning 5.5

GeocodeForm {

    property variant address
    signal showPlace(variant address)
    signal closeForm()

    goButton.onClicked: {
        // fill out the Address element
        address.street = street.text
        address.city = city.text
        address.state = stateName.text
        address.country = country.text
        address.postalCode = postalCode.text
        showPlace(address)
    }

    clearButton.onClicked: {
        street.text = ""
        city.text = ""
        stateName.text = ""
        country.text = ""
        postalCode.text = ""
    }

    cancelButton.onClicked: {
        closeForm()
    }

    Component.onCompleted: {
        street.text = address.street
        city.text = address.city
        stateName.text = address.state
        country.text = address.country
        postalCode.text = address.postalCode
    }
}


