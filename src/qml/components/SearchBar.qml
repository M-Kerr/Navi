import QtQuick 2.0
import QtQuick.Controls 2.15
// TODO delete unused import
//import QtQuick.Controls.Material 2.0
import EsriSearchModel 1.0
import "../animations"
import "SoftUI"

Item {
    id: root
    height: 35

    property var night
    property color bgColor

    property alias input: searchBar.input
    property string text: input.text

    function activate() { activateAnim.start() }
    function deactivate() { deactivateAnim.start() }

    ActivateSearchBarAnimation { id: activateAnim }
    DeactivateSearchBarAnimation { id: deactivateAnim }

    Behavior on opacity { NumberAnimation {} }
    onEnabledChanged: {
        if (enabled) opacity = 1;
        else opacity = 0;
    }

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
                mainMapPage.state = ""
            }
        }
    }

    SoftCraterSearchBar {
        id: searchBar
    }
}
