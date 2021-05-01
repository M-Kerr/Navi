import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import EsriSearchModel 1.0
import Logic 1.0
import AppUtil 1.0
import "../animations"

MapQuickItem {
    id: root

    coordinate: place.location.coordinate
    anchorPoint {
        x: scope.width / 2
        y: scope.height + 40
    }
    clip: false

    property alias closeAnimation: closeAnimation
    property alias infoButton: infoButton

    onFocusChanged: {
        if (focus) {
            openAnimation.start();
        }
        // pass focus responsibility to infoButton
        else if (infoButton.focus);
        else {
            closeAnimation.start();
        }
    }

    OpenMarkerDialogAnimation { id: openAnimation }
    CloseMarkerDialogAnimation { id: closeAnimation }

    sourceItem: Item {
        id: scope

        // OpenMarkerDialogAnimation, CloseMarkerDialogAnimation animations
        // animate between the private _height;_width;_radius when the
        // place's marker glyph is selected.
        property real _height: {
            (imageRect.height / 2)
            + clipItem.anchors.topMargin + clipItem.anchors.bottomMargin
            + titleLabel.height
            + streetLabel.height + streetLabel.Layout.topMargin
            + cityStateLabel.height + cityStateLabel.Layout.topMargin
            + (infoButton.anchors.margins * 2) + infoButton.height
        }
        property real _width: 200
        property real _radius: _width / 8

        height: 0
        width: 0
        clip: false

        // Prevents clicks within the dialog from closing the dialog
        MouseArea {
            id: mouseArea

            preventStealing: true
            anchors.fill: parent
        }

        Rectangle {
            id : backgroundRect

            anchors.fill: parent
            radius: 0
            color: AppUtil.color.foreground
        }

        DropShadow {
            id: backgroundShadow

            anchors.fill: backgroundRect
            source: backgroundRect
            radius: 1.5
            samples: 9
            verticalOffset: 0.75
            color: AppUtil.color.foregroundDarkShadow
        }

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

        Item {
            id: clipItem

            clip: true
            anchors {
                top: imageRect.bottom
                left: parent.left
                right: parent.right
                bottom: infoButton.top
                topMargin: 5
                leftMargin: 5
                rightMargin: 5
                bottomMargin: 5
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Label {
                    id: titleLabel;

                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter

                    text:{
                        let i = place.name.indexOf(",")
                        if (i !== -1) place.name.slice(0, i);
                        else place.name
                    }
                    font: AppUtil.headerFont
                    color: AppUtil.color.fontPrimary
                }

                Label {
                    id: streetLabel

                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 8

                    text: {
                        if (place.location.address.street )
                            place.location.address.street + ",";
                        else "";
                    }
                    font: AppUtil.subHeaderFont
                    color: AppUtil.color.fontSecondary
                }

                Label {
                    id: cityStateLabel

                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 3

                    text: {
                        let addr = place.name.split(",").slice(2)
                        addr.slice(0, 2).join(",");
                    }
                    font: AppUtil.subHeaderFont
                    color: AppUtil.color.fontSecondary
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        DropShadow {
            id: infoButtonShadow

            anchors.fill: infoButton
            source: infoButton
            radius: 1
            samples: 6
            verticalOffset: 0.60
            color: AppUtil.color.backgroundDarkShadow
        }

        Rectangle {
            id: infoButton

            implicitHeight: infoLabel.height + 20
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 5
            }
            radius: width / 8
            color: AppUtil.color.background

            MouseArea {
                anchors.fill: parent

                preventStealing: true

                onFocusChanged: {
                    if (!focus) closeAnimation.start();
                }

                onClicked: {
                    Logic.selectPlace(model)
                    closeAnimation.start()
                }

                onPressed: infoButtonShadow.visible = false
                onReleased: infoButtonShadow.visible = true
                onExited: infoButtonShadow.visible = true
            }

            Label {
                id: infoLabel

                anchors.centerIn: parent

                text: "Info"
                font: AppUtil.headerFont
                color: AppUtil.color.fontPrimary
            }
        }
    }
}
