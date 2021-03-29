import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import QtPositioning 5.15
import EsriSearchModel 1.0
import "../components"

Page {
    id: placeInfoPage

    background: Item {}

    // TODO refactor PullPane into a component
    // and implement its details within PlaceInfoPage.
    // TODO Refactor PullPane's footer into placeInfoPage's footer
    BackButton {
        id: backButton
        onClicked: {
            placeInfoPage.StackView.view.fitViewportToMapItems()
            placeInfoPage.StackView.view.pop()
        }
    }

    CloseButton {
        id: closeButton
        onClicked: {
            placeInfoPage.StackView.view.fitViewportToMapItems()
            placeInfoPage.StackView.view.unwind()
        }
    }

    PullPane {
        id: pullPane

        property Place place: EsriSearchModel.selectedPlace
        property real placeDistance: EsriSearchModel.selectedPlaceDistance

        Rectangle {
            id: imageRect
            height: 30
            width: 30
            radius: height / 2
            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: markerImage
                anchors.centerIn: parent
                //            source: "qrc://marker.png"
                source: "../resources/marker.png"
                scale: 0.4
            }
        }

        DropShadow {
            id: imageRectShadow
            anchors.fill: imageRect
            source: imageRect
            radius: 1.5
            samples: 9
            verticalOffset: 0.75
        }

        ColumnLayout {
            id: clipItem
            clip: true

            anchors.top: imageRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 15
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 5

            spacing: 10

            // TODO:
            // If the section doesn't exist, the ColumnLayout.visible = false
            ColumnLayout {
                id: titleSection
                Layout.alignment: Qt.AlignHCenter
                //                anchors.top: parent.top
                //                anchors.right: parent.right
                //                anchors.left: parent.left
                spacing: 4

                Label {
                    id: nameLabel;
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter

                    text:{
                        if (pullPane.place)
                        {
                            let i = pullPane.place.name.indexOf(",")
                            if (i !== -1) pullPane.place.name.slice(0, i);
                            else pullPane.place.name
                        }
                        else ""
                    }

                    font { family: "Arial"; bold: true }
                }

                Label {
                    id: streetCityLabel
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter
                    visible: text

                    font { family: "Arial" }
                    color: "grey"
                    text: {
                        let t = ""

                        if (pullPane.place) {
                            if (pullPane.place.location.address.street
                                    && pullPane.place.location.address.city)
                            {
                                t += pullPane.place.location.address.street + ", "
                                t += pullPane.place.location.address.city
                            }
                            else if (pullPane.place.location.address.street)
                                t += pullPane.place.location.address.street;
                            else if (pullPane.place.location.address.city)
                                t += pullPane.place.location.address.city;
                        }

                        return t
                    }
                }

                Label {
                    id: contactPhone
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        if (pullPane.place) "Phone: " + pullPane.place.primaryPhone;
                        else "";
                    }

                    font.family: "Arial"
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    id: distance
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                       if ( pullPane.place ) {
                            Math.round(
                                (pullPane.placeDistance / 1760) * 100
                                ) / 100 + " miles away" ;
                       }
                       else "";
                    }
                    font {
                        family: "Arial"
                        weight: Font.Thin
                    }
                }
            }

            Item {id: filler; Layout.fillHeight: true }
        }
    }

    footer: Rectangle {
        id: footerItem

        height: navigateButton.implicitHeight
        width: parent.width

        Button {
            id: navigateButton

            width: parent.width; height: parent.height
            anchors.centerIn: parent

            text: "Navigate"

//            onDownChanged: {
//                if (down) footerShadow.visible = false;
//                else footerShadow.visible = true
//            }
        }

        DropShadow {
            id: footerShadow
            anchors.fill: navigateButton
            source: navigateButton
            radius: 8
            samples: 32
//            verticalOffset: 0.15
            spread: 0
        }
    }
}
