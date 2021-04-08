import QtQuick 2.15

QtObject {
    property list<State> states: [
        State {
            name: ""
            PropertyChanges {
                target: searchPage
                visible: false
                opacity: 0
            }
            PropertyChanges {
                target: map;
                tilt: 0;
                bearing: 0;
                zoomLevel: map.zoomLevel
            }
            AnchorChanges {
                target: searchPage
                anchors.bottom: root.top
                anchors.top: root.top
                anchors.left: root.left
                anchors.right: root.right
            }
            PropertyChanges {
                target: root
                focus: true
            }
            PropertyChanges {
                target: directionsView
                visible: false
            }
        },
        State {
            name: "searchPage"
            PropertyChanges {
                target: searchPage
                visible: true
                opacity: 1
            }
            AnchorChanges {
                target: searchPage;
                anchors.bottom: root.bottom
                anchors.top: root.top
                anchors.left: root.left
                anchors.right: root.right
            }
        },
        State {
            name: "following"
            // TODO: Change tilt and zoomLevel to more comfortable values
            PropertyChanges { target: map; tilt: 60; zoomLevel: 20 }
        },
        State {
            name: "navigating"
            PropertyChanges {
                target: searchBar
                enabled: false
            }
            PropertyChanges {
                target: endNavigationButton
                visible: true
            }
            PropertyChanges {
                target: directionsView
                visible: true
            }
        }
    ]

    property list<Transition> transitions: [
        Transition {
            from: "*"
            to: "following"
            RotationAnimation { target: map; property: "bearing"; duration: 100; direction: RotationAnimation.Shortest }
            NumberAnimation { target: map; property: "zoomLevel"; duration: 100 }
            NumberAnimation { target: map; property: "tilt"; duration: 100 }
        },
        Transition {
            from: "*"
            to: "navigating"
            ScriptAction { script: print("state = navigating") }
        },
        Transition {
            from: "*"
            to: "searchPage"
            AnchorAnimation { duration: 200 }
            NumberAnimation { target: searchPage;
                property: "opacity"; duration: 150 }
            ScriptAction { script: searchBar.activate() }
        },
        Transition {
            from: "searchPage"
            to: ""
            AnchorAnimation { duration: 200 }
            NumberAnimation { target: searchPage;
                property: "opacity"; duration: 150 }
            ScriptAction { script: searchBar.deactivate() }
        }
    ]
}
