pragma Singleton

import QtQuick 2.0

//    property real radius: 50
//    property real shadowRadius: 60
//    property color color: "#ebebeb"
//    property color lightSourceColor: "#ffffff"
//    property color shadowColor: "#c8c8c8"

//    property alias topShadow: topShadow
//    property alias bottomShadow: bottomShadow
//    property alias topInnerShadow: topInnerShadow
//    property alias bottomInnerShadow: bottomInnerShadow
//    property alias topInnerShadowClipBox: topInnerShadowClipBox
//    property alias bottomInnerShadowClipBox: bottomInnerShadowClipBox

QtObject {
    id: root

    property QtObject header: Text {
        font {
        }
    }

    property QtObject secondaryHeader: Text {
        font {
        }
    }

    property QtObject subHeader: Text {
        font {
        }
    }

    property QtObject body: Text {
        font {
        }
    }

    property QtObject fontFamilyPrimary: FontLoader {
        //            source:
    }
    property QtObject fontFamilySecondary: FontLoader {
        //            source:
    }

    property QtObject color: QtObject {
        property color primary
        property color secondary
        property color accent
        property color background
        property color backgroundSecondary
        property color fontPrimary
        property color fontSecondary
        property color fontAccent
    }
}
