import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import QtPositioning 5.15
import Logic 1.0
import "../components"
import "../components/SoftUI"

Page {
    id: root

    property Place place
    property real placeDistance

    background: Item {}

    BackButton {
        id: backButton
        onClicked: {
            Logic.backToPlacesMap()
        }
    }

    CloseButton {
        id: closeButton
        onClicked: {
            Logic.fitViewportToPlacesMapView()
            Logic.unwindStackView()
        }
    }

    GlassPullPane {
        id: glassPullPane

        source: mainMapPage
        blurRadius: 40
        color {
            hsvHue: 0
            hsvSaturation: 0
            hsvValue: 0.90
            a: 0.70
        }

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
                        if (root.place)
                        {
                            let i = root.place.name.indexOf(",")
                            if (i !== -1) root.place.name.slice(0, i);
                            else root.place.name
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

                        if (root.place) {
                            if (root.place.location.address.street
                                    && root.place.location.address.city)
                            {
                                t += root.place.location.address.street + ", "
                                t += root.place.location.address.city
                            }
                            else if (root.place.location.address.street)
                                t += root.place.location.address.street;
                            else if (root.place.location.address.city)
                                t += root.place.location.address.city;
                        }

                        return t
                    }
                }

                Label {
                    id: contactPhone
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        if (root.place) "Phone: " + root.place.primaryPhone;
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
                       if ( root.place ) {
                            Math.round(
                                (root.placeDistance / 1760) * 100
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

        height: directionsButton.implicitHeight
        width: parent.width
//        color: "transparent"

        Button {
            id: directionsButton

            implicitHeight: 40
            width: parent.width
            anchors.centerIn: parent

            text: "Directions"

            onClicked: {
                // NOTE: instead of calling endNavigation(), should check for
                // navigating state and prompt user to end navigating to
                // previous destination
                Logic.endNavigation()
                Logic.addWaypointAndGetDirections ( place.location.coordinate )
            }

            background: SoftGlassBox {
                source: mainMapPage
                blurRadius: glassPullPane.blurRadius * 2
                glassOpacity: glassPullPane.glassOpacity * 2
                radius: 0
                width: directionsButton.width + 1
                height: directionsButton.height + 1
                border {
                    width: 1
                    color {
                        hsvHue: 0.0
                        hsvSaturation: 0.0
                        hsvValue: 0.90
                        a: 0.40
                    }
                }
                shadow {
                    visible: true
                    horizontalOffset: 0
                    verticalOffset: -0.3
                    radius: 14
                }
            }
        }
//        DropShadow {
//            id: footerShadow
//            anchors.fill: directionsButton
//            source: directionsButton
//            radius: 8
//            samples: 32
//            spread: 0
//        }
    }
}
