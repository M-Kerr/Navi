import QtQuick 2.15

ParallelAnimation {
    id: openAnimation

    NumberAnimation {
        target: scope
        property: "height"
        to: scope._height
        easing {
            type: Easing.OutBack
            overshoot: 0.75
        }
        duration: 400
    }

    NumberAnimation {
        target: scope
        property: "width"
        to: scope._width
        easing.type: Easing.OutQuad
        duration: 200
    }

    NumberAnimation {
        target: backgroundRect
        property: "radius"
        to: scope._radius
        easing.type: Easing.OutQuad
        duration: 200
    }
}
