import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15
import QtGraphicalEffects 1.15
import EsriSearchModel 1.0
import "../animations"

Item {
    id: root
    height: 35

    property var night
    property color bgColor

    property alias input: input
    property string text: input.text

    function activate() { activateAnim.start() }
    function deactivate() { deactivateAnim.start() }

    ActivateSearchBarAnimation { id: activateAnim }
    DeactivateSearchBarAnimation { id: deactivateAnim }

    Rectangle {
        id: backRect
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: parent.height
        width:  0
        radius: width
        color: root.bgColor
        clip: true
        enabled: false
        opacity: 0.0

        Label {
            anchors.centerIn: parent
            text: "≺"
            font.bold: true
            font.family: "Arial"
            color: night? "grey" : "black"
        }

        MouseArea {
            id: backRectMouseArea
            anchors.fill: parent
            onClicked: {
                mainMapPage.previousState();
            }
        }
    }

    Rectangle {
        id: inputRect

        anchors.left: backRect.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 15

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

        Item {
            id: searchIcon

            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            height: parent.height * 0.5
            width: height

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

            anchors.left: searchIcon.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: clearSearchTerm.left

            placeholderText: "Where to?"
            background: Item {} // Transparent background

            font.family: "Arial"

            onActiveFocusChanged: {
                if (activeFocus) {
                    mainMapPage.state = "searchPage";
                }
            }

            onAccepted: {
                if (text)
                {
                    mainMapPage.previousState()
                }
            }
        }

        Rectangle {
            id: clearSearchTerm

            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            height: parent.height * 0.5
            width: height
            radius: height / 2

            visible: input.text.length > 0

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 2
                samples: 9
                verticalOffset: 0.75
                horizontalOffset: -0.75
            }

            Label {
                anchors.centerIn: parent
                text: "X"
                font.pixelSize: parent.height / 2
                font.family: "Arial"
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
