// Transforms the visible search bar to receive key input. I.e.,
// Animates out the search icon, animates in the back button. Doesn't affect
// the search bar's enable or visible properties.
import QtQuick 2.0

SequentialAnimation {
    id: backRectShow

    ScriptAction {
        script: {
            deactivateAnim.stop()
            backRect.enabled = true;
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

        NumberAnimation {
            target: backRect
            property: "width"
            to: height
            duration: 100
        }

        NumberAnimation {
            target: searchIcon
            property: "width"
            to: 0
            duration: 100
        }
    }

    PropertyAction {
        target: searchIcon
        property: "visible"
        value: false
    }
}
