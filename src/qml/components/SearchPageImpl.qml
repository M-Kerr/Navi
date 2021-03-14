import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import com.mkerr.navi 1.0
import MapboxSearchModel 1.0
import GlobalStatus 1.0

ColumnLayout {
    id: resultColumn
    anchors.fill: parent
    spacing: 0

    property bool night

    Item {
        id: headerWrapper
        Layout.fillWidth: true
        height: 90
        z: 1

        Rectangle {
            id: headerRect
            anchors.fill: parent
            color: "white"
        }
        DropShadow {
            source: headerRect
            anchors.fill: headerRect
            radius: 16
            samples: 32
            verticalOffset: -0.15
        }
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
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: MapboxSearchModel
//        spacing: -1
//        clip: true
        visible: GlobalStatus.searching

        delegate:
            Frame {
            contentWidth: listView.width
            contentHeight: 60
            z: listView.currentIndex === model.index ? 2 : 1

            Component.onCompleted: print("Result Element created")

            background: Rectangle {
                border.width: 1
                border.color: night? Qt.lighter(color, 1.15) : Qt.darker(color, 1.2)
                color: bgColor
            }

            RowLayout {
                anchors.fill: parent
                spacing: 15

                Item {
                    id: markerRect
                    height: parent.height * 0.5
                    width: height
                    Layout.leftMargin: 15
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: {
                            if (place.icon.url().toString())
//                                "qrc:///" + place.icon.url().toString().slice(7);
                                "../resources/" + place.icon.url().toString().slice(7);

                            else "../resources/marker2.png"
                        }
                    }
                }

                Item {
                    height: parent.height * 0.5
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 3

                        // TODO: if/else logic to determine place result type
                        // and its visual representation
                        Label {
                            height: parent.height / 2
                            text: title
                            font.bold: true
                        }
                        Label {
                            height: parent.height / 2
                            text: place.location.address.street
                        }
                    }
                }

                Item {
                    height: parent.height * 0.5
                    width: height + 13
                    Layout.rightMargin: 25
                    Layout.alignment: Qt.AlignVCenter
                    clip: true

                    ColumnLayout {
                        id: distanceRect
                        anchors.fill: parent
                        spacing: 0

                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: Math.round(distance)
                            font.bold: true
                            verticalAlignment: Text.AlignBottom
                        }
                        Label {
                            Layout.alignment: Qt.AlignHCenter
                            text: "meters"
                            font.weight: Font.Thin
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }
            }
        }
    }
}
