import QtQuick 2.15

ParallelAnimation {
    id: openAnimation

    NumberAnimation {
        target: scope
        property: "height"
        to: scope._height
        easing {
            type: Easing.OutElastic
            amplitude: 1
            period: 0.45
        }
        duration: 600
    }

    NumberAnimation {
        target: scope
        property: "width"
        to: scope._width
        easing {
            type: Easing.OutElastic
            amplitude: 1
            period: 0.45
        }
        duration: 700
    }

    NumberAnimation {
        target: backgroundRect
        property: "radius"
        to: scope._radius
        easing {
            type: Easing.OutElastic
            amplitude: 1
            period: 0.45
        }
        duration: 1000
    }
}
