import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import QtPositioning 5.15
import Logic 1.0
import AppUtil 1.0
import "../components"
import "../components/SoftUI"

Item {
    id: root

    property Place place
    property real placeDistance

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
        color: AppUtil.color.foreground

        Rectangle {
            id: imageRect

            height: 30
            width: 30
            anchors {
                verticalCenter: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            radius: height / 2
            color: AppUtil.color.background

            Image {
                id: markerImage

                anchors.centerIn: parent
                //            source: "qrc://marker.png"
                source: "../resources/marker.png"
                scale: 0.4
            }

            MouseArea {
                anchors.fill: parent

                onPressed: {
                    glassPullPane.startDrag(mouse)
                }

                onReleased: glassPullPane.stopDrag()

                onPositionChanged: {
                    glassPullPane.drag(mouse)
                }
            }
        }

        DropShadow {
            id: imageRectShadow

            anchors.fill: imageRect

            source: imageRect
            radius: 1.5
            samples: 9
            verticalOffset: 0.75
            color: AppUtil.color.backgroundDarkShadow
        }

        ColumnLayout {
            id: clipItem

            clip: true

            anchors {
                top: imageRect.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 15
                leftMargin: 20
                rightMargin: 20
                bottomMargin: 5
            }

            spacing: 10

            ColumnLayout {
                id: titleSection

                Layout.alignment: Qt.AlignHCenter

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
                    font: AppUtil.headerFont
                    color: AppUtil.color.fontPrimary
                }

                Label {
                    id: streetCityLabel

                    width: parent.width

                    Layout.alignment: Qt.AlignHCenter

                    visible: text
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
                    font: AppUtil.subHeaderFont
                    color: AppUtil.color.fontSecondary
                }

                Label {
                    id: contactPhone

                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter

                    text: {
                        if (root.place) "Phone: " + root.place.primaryPhone;
                        else "";
                    }
                    font: AppUtil.bodyFont
                    color: AppUtil.color.fontPrimary
                }

                Label {
                    id: distance

                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter

                    text: {
                        if ( root.place ) {
                            // meters to miles conversion
                            Math.round((root.placeDistance / 1609) * 100) / 100
                                    + " miles away (geodesic)" ;
                        }
                        else "";
                    }
                    font: AppUtil.bodyFont
                    color: AppUtil.color.fontPrimary
                }
            }

            Item {id: filler; Layout.fillHeight: true }
        }

        Component.onCompleted: {
            color.a = 0.80
        }
    }

    Button {
        id: directionsButton

        implicitHeight: 40
        width: parent.width
        anchors.bottom: parent.bottom
        leftInset: -1
        rightInset: -1

        onClicked: {
            // NOTE in a future update:
            // instead of calling endNavigation(), should check for
            // navigating state and prompt user to end navigating to
            // previous destination
            Logic.endNavigation()
            Logic.addWaypointAndGetDirections ( place.location.coordinate )
        }

        onDownChanged: {
            if (down) {
                background.shadow.visible = false
                background.blurRadius *= 1.2
                directionsLabel.scale = 0.95
            } else {
                background.shadow.visible = true
                background.blurRadius /= 1.2
                directionsLabel.scale = 1.0
            }
        }

        background: SoftGlassBox {

            source: mainMapPage
            color: AppUtil.color.background
            blurRadius: glassPullPane.blurRadius * 2
            border {
                width: 0
                color: AppUtil.color.backgroundBorder
            }
            shadow {
                visible: true
                horizontalOffset: 0
                verticalOffset: 0
                radius: 6
                color: AppUtil.color.backgroundDarkShadow
            }
        }

        Label {
            id: directionsLabel

            anchors.centerIn:directionsButton
            text: "Directions"
            font: AppUtil.headerFont
            color: AppUtil.color.fontSecondary
        }
    }
}






























