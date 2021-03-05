import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Pane {
    id: root
//    width: parent.width
//    height: parent.height

    property alias header: headerRect
    property var model
    property var bgColor

//    background: Rectangle {
//        anchors.fill: parent
//        color: root.bgColor
//    }

    ColumnLayout {
        anchors.fill: parent

        // Header color-row
        Rectangle {
            id: headerRect
            width: parent.width
            height: 80
            color: "white"
        }

        // TODO: Categories row. Can be some kind of ToolBar with separators

        // ListView
        ListView {
            width: parent.width
            Layout.fillHeight: true
            model: root.model
            delegate: Rectangle {

                height: 60
                width: parent.width
                border.width: 1
                border.color: "darkgrey"
                color: bgColor

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Rectangle {
                        id: markerRect
                        height: parent.height * 0.5
                        width: height
                        Layout.leftMargin: 5
                        Layout.alignment: Qt.AlignVCenter

                        color: bgColor
                        // TODO: border

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            source: icon.url(icon.parameters["singleUrl"])
                        }
                    }

                    ColumnLayout {
                        height: parent.height * 0.5
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        // TODO: lots of if/else logic should be here to
                        // determine the place's representation
                        Text { text: title; font.bold: true }
                        Text { text: place.location.address.street }
                    }

                    Rectangle {
                        id: distanceRect
                        height: parent.height * 0.5
                        width: height
                        Layout.alignment: Qt.AlignVCenter

                        Text { text: distance + "m" }
                    }
                }
            }
        }
    }
}
