import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import com.mkerr.navi 1.0

ColumnLayout {
    id: resultColumn
    anchors.fill: parent
    spacing: 0

    property bool night

    Item {
        id: headerWrapper
        Layout.fillWidth: true
        height: 80
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

    // TODO: Categories row. Should be some kind of ToolBar or TabBar
    //    with ToolSeparators

    // ListView
    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: root.model
        spacing: -1
        clip: true
        delegate:
            Pane {
            contentWidth: listView.width
            contentHeight: 60
//            Rectangle {
//            height: 60

//            width: listView.width + (border.width * 2)
//            transform: Translate {x: -1}
//            border.width: 1
//            border.color: night? Qt.lighter(color, 1.15) : Qt.darker(color, 1.2)
//            color: bgColor

            z: listView.currentIndex === model.index ? 2 : 1

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
                                "../../../resources/" + place.icon.url().toString().slice(7);

                            // TODO: else display a default marker
                            // icon
                            else "../../../resources/marker2.png"
                        }
                    }
                }

                Item {
                    height: parent.height * 0.5
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

//                    Column {
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 3

                        // TODO: lots of if/else logic should be here to
                        // determine the place's representation
                        Label {
//                        Text {
                            height: parent.height / 2
                            text: title
                            font.bold: true
                        }
                        Label {
//                        Text {
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
//                        spacing: 0.5

                        // TODO: Unit setting with meters to miles conversion
                        Label {
//                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Math.round(distance)
                            font.bold: true
//                            color: "darkgrey"
                            verticalAlignment: Text.AlignBottom
//                            horizontalAlignment: Text.AlignHCenter
                        }
                        Label {
//                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "meters"
                            font.weight: Font.Thin
//                            color: "darkgrey"
                            verticalAlignment: Text.AlignTop
//                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
