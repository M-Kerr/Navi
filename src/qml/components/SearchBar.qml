import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtGraphicalEffects 1.15

Item {
    id: root
    height: 35

    property var plugin
    property var night
    property var currentCoordinate
    property color bgColor
    property var stateStack
    property alias input: input
    property string text: input.text

    SequentialAnimation {
        id: backRectShow

        ScriptAction {
            script: {
                backRectHide.stop()
                backRect.enabled = true;
                backRect.scale = 1.0
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: backRect
                property: "opacity"
                to: 1.0
                duration: 250
                easing.type: Easing.InQuad
            }
        }
    }

    SequentialAnimation {
        id: backRectHide

        ScriptAction {
            script: {
                backRectShow.stop()
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: backRect
                property: "opacity"
                to: 0.0
                duration: 250
                easing.type: Easing.OutQuad
            }
        }

        ScriptAction { script: backRect.enabled = false }
    }

    RowLayout {
        id: outerRow
        width: root.width
        height: root.height

        RoundButton {
//        Rectangle {
            id: backRect
            height: parent.height
            width:  height
            radius: height
//            color: root.bgColor
            clip: true
            enabled: false
            opacity: 0.0

            Material.elevation: 0

            Behavior on x { SmoothedAnimation { velocity: 200 } }
            Behavior on y { SmoothedAnimation { velocity: 200 } }
            Behavior on scale { NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            Label {
                anchors.centerIn: parent
                text: "≺"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (backRectHide.running) return;

                    backRectHide.start();
                    searchIconRect.visible = true;
                    stateStack.pop();
                    root.parent.state = stateStack[stateStack.length - 1];
                }
            }
        }

        Item {
            Layout.fillWidth: true
            height: parent.height

            InnerShadow {
                anchors.fill: inputRect
                source: inputRect
                radius: 6
                samples: 20
                //                spread: 0.15
                verticalOffset: 0.75
                horizontalOffset: -0.75
                z: 1
            }

            Rectangle {
                id: inputRect
                anchors.fill: parent
                radius: height / 2
                //            color: root.bgColor
                border.color: Qt.rgba(0, 0, 0, 0.01)
                border.width: 1
                clip: true

                Behavior on x { NumberAnimation { duration: 1000 } }
                Behavior on width { NumberAnimation { duration: 1000 } }

                Item {
                    id: searchIconRect
                    height: parent.height * 0.5
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        //                        source: "qrc:searchIcon.png"
                        source: "../resources/searchIcon.png"
                        asynchronous: true
                    }
                }

                TextField {
                    id: input
                    height: parent.height //* 0.5
                    width: parent.width - searchIconRect.width - 50

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 4
                    anchors.left: searchIconRect.right
                    anchors.leftMargin: 20

                    placeholderText: "Where to?"
//                    background: Item {} // Transparent background

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            searchIconRect.visible = false;
                            backRectShow.start();
                        }
                    }
                }
            }
        }
    }
}
