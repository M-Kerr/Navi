import QtQuick 2.15

SequentialAnimation {
    id: closeAnimation

    ScriptAction { script: openAnimation.stop() }

    ParallelAnimation {

        NumberAnimation {
            target: scope
            property: "height"
            to: 0
            duration: 250
            easing {
                type: Easing.InBack
                overshoot: 2
            }
        }

        NumberAnimation {
            target: scope
            property: "width"
            to: 0
            duration: 235
            easing {
                type: Easing.InBack
                overshoot: 2
            }
        }

        NumberAnimation {
            target: backgroundRect
            property: "radius"
            to: 0
            duration: 250
            easing {
                type: Easing.InBack
                overshoot: 2
            }
        }
    }
}
