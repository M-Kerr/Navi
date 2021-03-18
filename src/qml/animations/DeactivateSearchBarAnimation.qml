import QtQuick 2.0

SequentialAnimation {
    id: backRectHide

    ScriptAction {
        script: {
            activateAnim.stop()
            searchIcon.visible = true
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

        NumberAnimation {
            target: backRect
            property: "width"
            to: 0
            duration: 100
        }

        NumberAnimation {
            target: searchIcon
            property: "width"
            to: searchIcon.height
            duration: 100
        }
    }

    ScriptAction { script: backRect.enabled = false }
}
