import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
//import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import Logic 1.0
import AppUtil 1.0
import "qrc:/SoftUI"

Control {
    id: root
    anchors.fill: parent

    property bool night

    wheelEnabled: true
    Rectangle {
        id: headerRect

        z: 1
        height: 90
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        color: AppUtil.color.foreground
        opacity: 0.01
    }

    Item {

        z: 1
        height: 20
        anchors {
            top: headerRect.bottom
            left: headerRect.left
            right: headerRect.right
        }
        clip: true

        DropShadow {

            y: -height
            height: headerRect.height
            width: headerRect.width

            source: headerRect
            radius: 16
            samples: 32
            verticalOffset: -0.15
            color: AppUtil.color.foregroundDarkShadow
        }
    }

    SoftGlassBox {
        id: softGlassBox

        anchors.fill: root

        source: map
        radius: 0
        blurRadius: 60
        color: AppUtil.color.foreground
        Component.onCompleted: {
            color.a = 0.90
        }

//        color {
//            hsvHue: 0
//            hsvSaturation: 0
//            hsvValue: 0.92
//            a: 0.80
//        }
    }

    ListView {
        id: listView

        anchors {
            left: parent.left
            right: parent.right
            top: headerRect.bottom
            bottom: parent.bottom
        }

        model: EsriSearchModel
        clip: true

        // TODO: This Frame is improperly implemented.? Provide it a RowLayout
        // as its contentItem's child? Although, its current implementation
        // already works for dynamic sizing, and should be slightly more
        // performant because it doesn't use a RowLayout.
        delegate: Frame {
            id: frame

            width: listView.width
            height: 110

            leftInset: -1
            rightInset: -1
            background: Rectangle {
                border {
                    width: (index % 2 === 1)? 1: 0
                    color: AppUtil.color.backgroundBorder
                }

                color: "transparent"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Logic.selectPlace(model)
                    frame.z = 0
                    body.scale = 1
                }
                onPressed: {
                    frame.z = 1
                    body.scale = 0.99
                }
                onCanceled: {
                    frame.z = 0
                    body.scale = 1
                }
            }

            Item {
                id: body
                anchors.fill: parent

                Item {
                    id: markerRect
                    height: parent.height * 0.5
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: "qrc:/resources/marker2.png"
                    }
                }

                ColumnLayout {
                    id: placeNameAddressColumn

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: markerRect.right
                        right: distanceColumn.left
                        leftMargin: 15
                        rightMargin: 15
                    }

                    spacing: 6
                    clip: true

                    Label {
                        id: placeNameLabel

                        Layout.maximumWidth: placeNameAddressColumn.width
                        Layout.alignment: Qt.AlignLeft

                        text:{
                            let i = place.name.indexOf(",")
                            if (i !== -1) place.name.slice(0, i);
                            else place.name
                        }
                        font: AppUtil.headerFont
                        color: AppUtil.color.fontPrimary
                        wrapMode: Text.Wrap
                    }

                    Label {
                        id: placeAddressLabel

                        Layout.maximumWidth: placeNameAddressColumn.width
                        Layout.alignment: Qt.AlignLeft

                        text: place.location.address.street
                        font: AppUtil.subHeaderFont
                        color: AppUtil.color.fontSecondary
                        wrapMode: Text.Wrap
                    }
                }

                ColumnLayout {
                    id: distanceColumn
                    height: parent.height * 0.5
                    width: height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    spacing: 6

                    Label {
                        id: milesValueLabel

                        Layout.alignment: Qt.AlignHCenter

                        // PlaceSearchModel returns geodesic meters
                        // (as the crow flies).
                        // meters -> miles
                        text: Math.round((distance / 1609) * 100) / 100
                        font: AppUtil.headerFont
                        color: AppUtil.color.fontPrimary
//                        verticalAlignment: Text.AlignBottom
                    }

                    Label {
                        id: milesTextLabel
                        Layout.alignment: Qt.AlignHCenter
                        text: "miles"
                        font: AppUtil.subHeaderFont
                        color: AppUtil.color.fontSecondary
//                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
}
