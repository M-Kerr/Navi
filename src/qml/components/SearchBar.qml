import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtGraphicalEffects 1.15
import MapboxSearchModel 1.0

Item {
    id: root
    height: 35

    property var plugin
    property var night
    property alias input: input
    property color bgColor

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

        Rectangle {
            id: backRect
            height: parent.height
            width:  height
            radius: height
            color: root.bgColor
            clip: true
            enabled: false
            opacity: 0.0

            Behavior on x { SmoothedAnimation { velocity: 200 } }
            Behavior on y { SmoothedAnimation { velocity: 200 } }
            Behavior on scale { NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            Text {
                anchors.centerIn: parent
                text: "≺"
                font.bold: true
                color: night? "grey" : "black"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (backRectHide.running) return;

                    input.text = ""
                    backRectHide.start();
                    searchIcon.visible = true;
                    itemWindow.previousState();
                }
            }
        }

        Rectangle {
            id: inputRect
            Layout.fillWidth: true
            height: parent.height
            radius: height / 2
            color: root.bgColor
            border.color: Qt.rgba(0, 0, 0, 0.01)
            border.width: 1
            clip: true
            layer.enabled: true
            layer.effect: InnerShadow {
                radius: 6
                samples: 20
                verticalOffset: 0.75
                horizontalOffset: -0.75
            }

            Behavior on x { NumberAnimation { duration: 1000 } }
            Behavior on width { NumberAnimation { duration: 1000 } }

            RowLayout {
                id: inputRow
                anchors.fill: parent

                Item {
                    id: searchIcon
                    height: inputRow.height * 0.5
                    width: height
                    Layout.leftMargin: 20
//                    color: root.bgColor

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
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    placeholderText: "Where to?"
                    background: Item {} // Transparent background

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            searchIcon.visible = false;
                            backRectShow.start();
                        }
                    }

                    onAccepted: {
                        if (text)
                        {
                            itemWindow.previousState()
                        }
                    }
                }

//                Item {
//                    height: inputRow.height * 0.3
//                    width: height
//                    Layout.rightMargin: 20
//                    visible: input.text.length > 0
//                    clip: true

                Rectangle {
                    id: clearSearchTerm
                    height: inputRow.height * 0.5
                    width: height
                    Layout.rightMargin: 20
                    visible: input.text.length > 0
                    radius: height / 2
                    layer.enabled: true
                    layer.effect: DropShadow {
                        radius: 2
                        samples: 9
                        verticalOffset: 0.75
                        horizontalOffset: -0.75
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "X"
                        font.pixelSize: parent.height / 2
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: input.text = ""
                        onPressed: {
                            parent.scale = 1.25
                            parent.layer.enabled = false
                        }
                        onReleased: {
                            parent.scale = 1
                            parent.layer.enabled = true
                        }
                    }
                }
            }
        }
    }
}
