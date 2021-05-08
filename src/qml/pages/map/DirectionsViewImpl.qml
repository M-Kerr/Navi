/**

  Were going to make the main direcctions two Rows, first, current directions,
  second, upcoming directions.
  Both will have a MouseArea that makes a ListView visible when pressed,
  Which contains every direction in the route.

  The current direction in the Listview will be highlighted at the top of the
  page. The directions will be scrollable with the completed directions greyed
  out.

  Even better, the ListView will contain a toggle `property bool open`
  When not open, the first two row states will be visible, and interactive false.

  When open, the second row is invisible and the remaining directions appear

  **/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtPositioning 5.15
import QtLocation 5.15
import EsriRouteModel 1.0
import Logic 1.0
import GPS 1.0
import AppUtil 1.0
import "../../components"
import "../../components/SoftUI"

Item {
    id: root

    // WARNING: Demo purposes only, don't use GPS.ruler.nextTurnInstructionIndex
    // for actual vehicle tracking
    property int currentDirectionIndex: GPS.ruler.nextTurnInstructionIndex

    anchors.fill: parent

    Rectangle {
        id: headerRect

        height: parent.height * 0.2

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        color: AppUtil.color.fontPrimary

        ColumnLayout {
            id: headerColumn

            anchors {
                fill: parent
                margins: 10
            }

            spacing: 3

            Label {
                id: headerRectLabel

                Layout.maximumWidth: headerColumn.width
                Layout.alignment: Qt.AlignHCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: ""
                font: AppUtil.headerFont
                color: AppUtil.color.foreground

                Component.onCompleted: {
                    font.pixelSize = 16
                }
            }

            Label {
                id: headerRectDistanceLabel

                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: headerColumn.width

                visible: text
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font: AppUtil.secondaryHeaderFont
                color: AppUtil.color.foreground

                Component.onCompleted: {
                    font.pixelSize = 14
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }

        function updateText() {
            let segment = root.currentDirectionIndex ?
                    EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex]
                  : null
            if (segment) {
                if (segment.maneuver.valid) {
                    headerRectLabel.text = segment.maneuver.instructionText
                    headerRectDistanceLabel.text = "Travel "
                            // meters -> ft
                            + Math.round(segment.distance * 3.281) + " ft."
                } else {
                    //                    root.currentDirectionIndex++
                    print("maneuver invalid, headerRect increased currentDirectionIndex. Index is now:", root.currentDirectionIndex)
                }
            } else {
                headerRectLabel.text = "Segment Invalid"
                headerRectDistanceLabel.text = ""
            }
        }
    }

    Rectangle {
        id: nextInstructionRect

        property alias text: nextInstructionRectLabel.text

        // WARNING: Having a height will break the openAnimation when animate
        // open on load is implemented.

        height: headerRect.height * 0.66

        width: listView.width
        anchors {
            top: headerRect.bottom
            left: parent.left
            right: parent.right
        }

        color: AppUtil.color.background
        visible: text !== ""
        clip: true

        SequentialAnimation {
            id: nextInstructionRectOpenAnimation
            alwaysRunToEnd: false

            PauseAnimation { duration: 500 }

            NumberAnimation {
                target: nextInstructionRect
                property: "height"
                to: headerRect.height * 0.66
                duration: 450
                easing {
                    type: Easing.OutQuad
                }
            }
        }

        NumberAnimation {
            id: nextInstructionRectCloseAnimation
            alwaysRunToEnd: false

            target: nextInstructionRect
            property: "height"
            to: 0
            duration: 100
            easing {
                type: Easing.OutQuad
            }
        }

        ColumnLayout {
            id: nextInstructionColumn

            anchors {
                fill: parent
                margins: 10
            }

            spacing: 3

            Label {
                id: nextInstructionRectLabel

                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: nextInstructionColumn.width

                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                text: ""
                color: AppUtil.color.fontSecondary
                font: AppUtil.secondaryHeaderFont

                Component.onCompleted: {
                    font.pixelSize = 12
                }
            }

            Label {
                id: nextInstructionRectDistanceLabel

                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: nextInstructionColumn.width

                visible: text
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                color: AppUtil.color.fontSecondary
                font: AppUtil.secondaryHeaderFont

                Component.onCompleted: {
                    font.pixelSize = 12
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                listView.open = !listView.open
            }
        }

        function updateText() {
            let segment = root.currentDirectionIndex ?
                    EsriRouteModel.routeModel.get(0).segments[root.currentDirectionIndex + 1]
                  : null
            if (segment) {
                if (segment.maneuver.valid) {
                    nextInstructionRectLabel.text = segment.maneuver.instructionText
                    nextInstructionRectDistanceLabel.text = "Travel "
                            // meters -> ft
                            + Math.round(segment.distance * 3.281) + " ft."
                }
            } else {
                nextInstructionRectLabel.text = ""
                nextInstructionRectDistanceLabel.text = ""
            }
        }
    }

    ListView {
        id: listView

        property bool open: false
        property real delegateHeight: headerRect.height / 2
        property real _maxHeight: parent.height - headerRect.height

        anchors {
            top: nextInstructionRect.bottom
            left: parent.left
            right:parent.right
        }

        boundsMovement: Flickable.StopAtBounds
        currentIndex: root.currentDirectionIndex
        highlightFollowsCurrentItem: true
        snapMode: ListView.SnapToItem
        spacing: 0
        interactive: false
        clip: true

        model: ListModel {
            id: directionsListModel
        }

        onOpenChanged: {
            if (open && EsriRouteModel.status === RouteModel.Ready) {
                nextInstructionRectOpenAnimation.stop()
                nextInstructionRectCloseAnimation.start()

                let segs = EsriRouteModel.routeModel.get(0).segments
                directionsListModel.clear()

                let newHeight = (segs.length - 1) * delegateHeight
                height = newHeight < _maxHeight ? newHeight : _maxHeight
                //                softGlassBox.height = height + headerRect.height

                interactive = true

                for (var i=0; i < segs.length; i++) {
                    directionsListModel.append({segment: segs[i]});
                }
            } else if (open && EsriRouteModel.status !== RouteModel.Ready) {
                open = false
            } else {
                interactive = false

                // Fixes remove transition bug when view isn't at beginning
                positionViewAtBeginning()

                for (let i=directionsListModel.count - 1; i >= 0 ; i--) {
                    directionsListModel.remove(i, 1);
                }

                nextInstructionRectCloseAnimation.stop()
                nextInstructionRectOpenAnimation.start()
            }
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "y"
                    duration: 250
                    easing {
                        type: Easing.OutQuad
                    }
                }

                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 50
                    easing {
                        type: Easing.OutQuad
                    }
                }
            }
        }

        remove: Transition {
            SequentialAnimation{

                PropertyAction {
                    property: "clipBox.width"
                    value: "columnLayout.width"
                }

                ParallelAnimation {

                    ColorAnimation {
                        to: AppUtil.color.foreground
                        duration: 200
                    }

                    NumberAnimation {
                        property: "clipBox.width"
                        to: 0
                        duration: 150
                        easing {
                            type: Easing.OutQuad
                        }
                    }

                    SequentialAnimation {

                        PauseAnimation {
                            duration: 75
                        }

                        ParallelAnimation {

                            NumberAnimation {
                                property: "y"
                                to: -listView.delegateHeight
                                duration: 300
                                easing {
                                    type: Easing.OutQuad
                                }
                            }

                            NumberAnimation {
                                property: "opacity"
                                to: 0.10
                                duration: 350
                                easing {
                                    type: Easing.OutQuad
                                }
                            }
                        }
                    }
                }
            }
        }

        removeDisplaced: Transition {
            NumberAnimation { property: "y"; duration: 250 }
        }

        delegate: Item {
            id: delegateItem

            property int staticIndex
            property bool hasManeuver: segment.maneuver && segment.maneuver.valid
            property alias instructionLabel: instructionLabel
            property alias instructionDistanceLabel: instructionDistanceLabel
            property alias clipBox: clipBox
            property alias columnLayout: columnLayout

            width: listView.width
            height: !visible? 0: ListView.view.delegateHeight

            Rectangle {
                id: delegateBackgroundRect

                anchors.fill: parent

                border {
                    width: 0.5
                    color: AppUtil.color.foregroundBorder
                }
                color: AppUtil.color.foreground
            }

            Item {
                // Workaround to fix small gaps between delegates when clip
                // enabled
                id: clipBox

                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                clip: true

                ColumnLayout {
                    id: columnLayout

                    anchors.centerIn: parent
                    spacing: 8

                    Label {
                        id: instructionLabel

                        Layout.alignment: Qt.AlignHCenter

                        wrapMode: Text.Wrap
                        text: {
                            if (hasManeuver) {
                                segment.maneuver.instructionText
                            }
                            else "";
                        }
                        color: {
                            if (staticIndex > root.currentDirectionIndex) {
                                AppUtil.color.fontPrimary
                            } else {
                                AppUtil.color.fontSecondary
                            }
                        }
                        font: AppUtil.subHeaderFont
                    }

                    Label {
                        id: instructionDistanceLabel

                        Layout.alignment: Qt.AlignHCenter

                        wrapMode: Text.Wrap
                        text: {
                            if (hasManeuver) {
                                // meters -> ft
                                "Travel " + Math.round(segment.distance * 3.281) + " ft."
                            }
                            else "";
                        }
                        color: {
                            if (staticIndex > root.currentDirectionIndex) {
                                AppUtil.color.fontPrimary
                            } else {
                                AppUtil.color.fontSecondary
                            }
                        }
                        font: AppUtil.subHeaderFont
                    }
                }
            }

            Component.onCompleted: {
                // index = -1 occurs when the element's remove animation runs,
                // causing bugs. Assign staticIndex = index when component completes
                staticIndex = index
                // We want the element to be visible only if it has a maneuver and
                // isn't the first or last turn instruction. listView.count
                // changes upon removal, so visible cannot be a binding.
                visible = (hasManeuver && 0 < staticIndex)
            }
        }
    }

    Connections {
        target: root

        function onCurrentDirectionIndexChanged () {
            headerRect.updateText();
            nextInstructionRect.updateText();
        }
    }

    Connections {
        target: Logic

        function onNavigate () {
            headerRect.updateText()
            nextInstructionRect.updateText()
        }

        function onEndNavigation () {
            directionsListModel.clear()
            listView.open = false
        }
    }
}
