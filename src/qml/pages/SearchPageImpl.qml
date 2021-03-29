import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import com.mkerr.navi 1.0
import EsriSearchModel 1.0

Item {
    id: searchPage
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
                    EsriSearchModel.selectPlace(model)
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

            Item {
                height: parent.height * 0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: markerRect.right
                anchors.right: distanceColumn.left
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                Layout.minimumWidth: 662
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 3
                    clip: true

                    // TODO: if/else logic to determine place result type
                    // and its visual representation
                    Label {
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
                        height: parent.height / 2
                        text: place.location.address.street
                        font.family: "Arial"
                    }
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
                    Layout.alignment: Qt.AlignHCenter
                    text: Math.round(distance)
                    font.bold: true
                    font.family: "Arial"
                    verticalAlignment: Text.AlignBottom
                }
                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: "meters"
                    font.weight: Font.Thin
                    font.family: "Arial"
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}
