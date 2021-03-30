import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import EsriSearchModel 1.0
import "../animations"

MapQuickItem {
    id: root

    coordinate: place.location.coordinate
    anchorPoint.x: scope.width / 2
    anchorPoint.y: scope.height + 40
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
            anchors.fill: parent
        }

        Rectangle {
            id : backgroundRect
            anchors.fill: parent
            radius: 0
        }

        DropShadow {
            id: backgroundShadow
            anchors.fill: backgroundRect
            source: backgroundRect
            radius: 1.5
            samples: 9
            verticalOffset: 0.75
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

        Item {
            id: clipItem
            clip: true

            anchors.top: imageRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: infoButton.top
            anchors.topMargin: 5
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5

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

                    font { family: "Arial"; bold: true }
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

                    font { family: "Arial" }
                    color: "grey"
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

                    font { family: "Arial" }
                    color: "grey"
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        RoundButton {
            id: infoButton

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 5
            radius: width / 8
            hoverEnabled: true

            text: "Info"
            font { family: "Arial"; bold: true }

            onFocusChanged: {
                if (!focus) closeAnimation.start();
            }
            onClicked: {
                EsriSearchModel.selectPlace(model)
                closeAnimation.start()
            }

            onPressed: infoButtonShadow.visible = false
            onReleased: infoButtonShadow.visible = true
            onHoveredChanged: if (!hovered) infoButtonShadow.visible = true
        }

        DropShadow {
            id: infoButtonShadow
            anchors.fill: infoButton
            source: infoButton
            radius: 1
            samples: 6
            verticalOffset: 0.60
        }
    }
}
