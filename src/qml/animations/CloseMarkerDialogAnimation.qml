import QtQuick 2.15

SequentialAnimation {
    id: closeAnimation

    ScriptAction { script: openAnimation.stop() }

    ParallelAnimation {

        NumberAnimation {
            target: scope
            property: "height"
            to: 0
            duration: 400
            easing {
                type: Easing.InBack
                overshoot: 1
            }
        }

        NumberAnimation {
            target: imageRect
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }

        NumberAnimation {
            target: scope
            property: "width"
            to: 0
            duration: 200
            easing {
                type: Easing.InBack
                overshoot: 3
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
