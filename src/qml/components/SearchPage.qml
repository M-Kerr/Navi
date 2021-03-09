import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15

Pane {
    id: root

    property alias header: headerRect
    property var model
    property var bgColor

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
            id: listView
            width: parent.width
            Layout.fillHeight: true
            model: root.model
            delegate: Rectangle {

                // TODO: use loader objects to load Components depending on the
                // result's `type`
                height: 60
                width: listView.width
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
                            source: {
                                if (place.icon.url().toString())
                                    "qrc:///" + place.icon.url().toString().slice(7);
                                // TODO: else display a default marker
                                // icon
                                else "";
                            }
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

                        // TODO: Unit setting with meters to miles conversion
                        Text { text: Math.round(distance) + " meters" }
                    }
                }
            }
        }
    }
}
