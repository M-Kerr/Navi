import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0
import Logic 1.0

Item {
    id: root
    anchors.fill: parent

    property bool night

    Rectangle {
        id: headerRect
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 90
        z: 1
        color: "white"
    }

    DropShadow {
        source: headerRect
        anchors.fill: headerRect
        radius: 16
        samples: 32
        verticalOffset: -0.15
    }

    //    ScrollView {
    //        id: categoriesView
    //        Layout.fillHeight: true
    //        Layout.fillWidth: true
    //        Frame {
    //            id: categoriesFrame
    //            width: parent.width
    //            height: 60
    //            visible: !GlobalStatus.searching

    //            background: Rectangle {
    //                border.width: 1
    //                border.color: night? Qt.lighter(color, 1.15) : Qt.darker(color, 1.2)
    //                color: bgColor
    //            }

    //            RowLayout {
    //                anchors.fill: parent
    //                ToolButton {
    //                    Layout.leftMargin: 20
    //                    width: (parent.width / 5) - 40 - (sep1.width * 4)
    //                    text: "C1"
    //                }
    //                ToolSeparator {id: sep1}
    //                ToolButton {
    //                    width: (parent.width / 5) - 40 - (sep1.width * 4)
    //                    text: "C2"
    //                }
    //                ToolSeparator {}
    //                ToolButton {
    //                    width: (parent.width / 5) - 40 - (sep1.width * 4)
    //                    text: "C3"
    //                }
    //                ToolSeparator {}
    //                ToolButton {
    //                    width: (parent.width / 5) - 40 - (sep1.width * 4)
    //                    text: "C4"
    //                }
    //                ToolSeparator {}
    //                ToolButton {
    //                    Layout.rightMargin: 20
    //                    width: (parent.width / 5) - 40 - (sep1.width * 4)
    //                    text: "⋯"
    //                }
    //            }
    //        }
    //    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerRect.bottom
        anchors.bottom: parent.bottom
        model: EsriSearchModel

        // TODO: This Frame is improperly implemented.? Provide it a RowLayout
        // as its contentItem's child? Although, its current implementation
        // already works for dynamic sizing, and should be slightly more
        // performant because it doesn't use a RowLayout.
        delegate: Frame {
            width: listView.width
            height: 110
            z: listView.currentIndex === model.index ? 2 : 1

            background: Rectangle {
                border.width: 1
                border.color: night? Qt.lighter(color, 1.15) : Qt.darker(color, 1.2)
                color: bgColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Logic.selectPlace(model)
                }
            }

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
                    source: "../resources/marker2.png"
                }
            }

            ColumnLayout {
                id: placeNameAddressColumn

                height: parent.height * 0.5
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: markerRect.right
                    right: distanceColumn.left
                    leftMargin: 15
                    rightMargin: 15
                }

                Layout.minimumWidth: 662
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                spacing: 3
                clip: true

                // TODO: if/else logic to determine place result type
                // and its visual representation
                Label {
                    id: placeNameLabel

                    height: parent.height / 2
                    text:{
                        let i = place.name.indexOf(",")
                        if (i !== -1) place.name.slice(0, i);
                        else place.name
                    }
                    font.bold: true
                    font.family: "Arial"
                }

                Label {
                    id: placeAddressLabel

                    height: parent.height / 2
                    text: place.location.address.street
                    font.family: "Arial"
                }
            }

            ColumnLayout {
                id: distanceColumn
                height: parent.height * 0.5
                width: height + 13
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 0

                Label {
                    id: milesValueLabel

                    Layout.alignment: Qt.AlignHCenter
                    text: Math.round((distance / 1760) * 100) / 100
                    font.bold: true
                    font.family: "Arial"
                    verticalAlignment: Text.AlignBottom
                }
                Label {
                    id: milesTextLabel
                    Layout.alignment: Qt.AlignHCenter
                    text: "miles"
                    font.weight: Font.Thin
                    font.family: "Arial"
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}
