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
            AnchorChanges {
                target: searchPage
                anchors {
                    bottom: root.top
                    top: root.top
                    left: root.left
                    right: root.right
                }
            }
            PropertyChanges {
                target: root
                focus: true
            }
            PropertyChanges {
                target: tripPullPane
                visible: false
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
                anchors {
                    bottom: root.bottom
                    top: root.top
                    left: root.left
                    right: root.right
                }
            }
        },
        State {
            name: "navigating"
            PropertyChanges {
                target: searchBar
                enabled: false
            }
            PropertyChanges {
                target: tripPullPane
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
            to: "navigating"
        },
        Transition {
            from: "navigating"
            to: ""
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
