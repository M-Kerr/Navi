import QtQuick 2.15

QtObject {
    property list<State> states: [
            State {
                name: ""
                PropertyChanges {
                    target: map;
                    tilt: 0;
                    bearing: 0;
                    zoomLevel: map.zoomLevel
                }
            },
            State {
                name: "following"
                // TODO: Change tilt and zoomLevel to more comfortable values
                PropertyChanges { target: map; tilt: 60; zoomLevel: 17 }
            }
    ]

    property list<Transition> transitions: [
            Transition {
                from: "*"
                to: "following"
                RotationAnimation { target: map; property: "bearing"; duration: 100; direction: RotationAnimation.Shortest }
                NumberAnimation { target: map; property: "zoomLevel"; duration: 100 }
                NumberAnimation { target: map; property: "tilt"; duration: 100 }
            }
    ]
}
