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
                anchors.bottom: mainMapPage.top
                anchors.top: mainMapPage.top
                anchors.left: mainMapPage.left
                anchors.right: mainMapPage.right
            }
            PropertyChanges {
                target: mainMapPage
                focus: true
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
                anchors.bottom: mainMapPage.bottom
                anchors.top: mainMapPage.top
                anchors.left: mainMapPage.left
                anchors.right: mainMapPage.right
            }
        }
    ]

    property list<Transition> transitions: [
        Transition {
            from: ""
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
