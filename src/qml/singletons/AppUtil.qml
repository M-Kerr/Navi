pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

//QtObject {
//    id: root

//    property font headerFont: Qt.font({bold: true, family: "Arial"})

////    property font secondaryHeaderFont: Qt.font({})

//    property font subHeaderFont: Qt.font({family: "Arial"})

////    property font bodyFont: Qt.font({})

//    property QtObject fontFamilyPrimary: FontLoader {
//        //            source:
//    }
//    property QtObject fontFamilySecondary: FontLoader {
//        //            source:
//    }

//    property QtObject color: QtObject {
//        property color primary: Qt.hsva(0.0, 0.0, 0.92, 1)
//        property color secondary: Qt.hsva(0.0, 0.0, 0.72, 1)
//        property color accent: Qt.hsva(1 * (1/360), 0.80, 0.72, 1)
//        property color background
//        property color backgroundSecondary
//        property color fontPrimary: Qt.hsva(6 * (1/360), 0.25, 0.32, 1)
//        property color fontSecondary: Qt.hsva(4 * (1/360), 0.10, 0.52, 1)
//        property color fontAccent
//    }
//}
QtObject {
    id: root

    property font headerFont: Qt.font({bold: true, family: "Arial"})

//    property font secondaryHeaderFont: Qt.font({})

    property font subHeaderFont: Qt.font({family: "Arial"})

    property font bodyFont: Qt.font({family: "Arial"})

    property QtObject fontFamilyPrimary: FontLoader {
        //            source:
    }
    property QtObject fontFamilySecondary: FontLoader {
        //            source:
    }

    property QtObject color: QtObject {
        // rename to background, foreground, accent,
        property color background: "#B9B7BD"
        property color backgroundBorder: Qt.darker(background, 1.2)
        property color backgroundLightShadow: Qt.lighter(background, 1.8)
        property color backgroundDarkShadow: Qt.darker(background, 2.5)
        property color foreground: "#EEEDE7"
        property color foregroundBorder: Qt.darker(foreground, 1.2)
        property color foregroundLightShadow: Qt.lighter(foreground, 1.8)
        property color foregroundDarkShadow: Qt.darker(foreground, 1.5)

//        property color accent // look on color wheel
//        property color accent: "#BD0A1C" // temporary
        property color accent: "#C44B4E" // temporary
        property color accentBorder: Qt.darker(accent, 1.2)
        property color accentLightShadow: Qt.lighter(accent, 1.8)
        property color accentDarkShadow: Qt.darker(accent, 3.0)

        property color fontPrimary: "#868B8E"
        property color fontSecondary: "#E7D2CC"
        property color fontAccent // look on color wheel
    }
}










