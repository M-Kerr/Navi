pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

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

    property font headerFont: Qt.font({bold: true, family: "Arial"})

//    property font secondaryHeaderFont: Qt.font({})

    property font subHeaderFont: Qt.font({family: "Arial"})

//    property font bodyFont: Qt.font({})

    property QtObject fontFamilyPrimary: FontLoader {
        //            source:
    }
    property QtObject fontFamilySecondary: FontLoader {
        //            source:
    }

    property QtObject color: QtObject {
        property color primary: Qt.hsva(0.0, 0.0, 0.92, 1)
        property color secondary: Qt.hsva(0.0, 0.75, 0.52, 1)
        property color accent
        property color background
        property color backgroundSecondary
        property color fontPrimary: Qt.hsva(6 * (1/360), 0.25, 0.32, 1)
        property color fontSecondary: Qt.hsva(4 * (1/360), 0.10, 0.52, 1)
        property color fontAccent
    }
}
