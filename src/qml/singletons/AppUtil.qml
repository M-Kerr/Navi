pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    id: root

//    property font headerFont: Qt.font({bold: true, family: latoBold.name})
    property font headerFont: Qt.font({bold: true, family: nunito.name})

    property font secondaryHeaderFont: Qt.font({family: nunito.name})

    property font subHeaderFont: Qt.font({family: lato.name})

    property font bodyFont: Qt.font({family: lato.name})

    property QtObject vollkorn: FontLoader {
                    source: "../resources/fonts/Vollkorn/Vollkorn-VariableFont_wght.ttf"
    }
    property QtObject lato: FontLoader {
                    source: "../resources/fonts/lato/Lato-Regular.ttf"
    }
    property QtObject latoBold: FontLoader {
                    source: "../resources/fonts/lato/Lato-Bold.ttf"
    }
    property QtObject oswald: FontLoader {
                    source: "../resources/fonts/oswald/Oswald-VariableFont_wght.ttf"
    }
    property QtObject nunito: FontLoader {
                    source: "../resources/fonts/nunito/Nunito-Bold.ttf"
    }

    property QtObject color: QtObject {
        property QtObject theme: slateTheme

        property color background: theme.background
        property color backgroundBorder: theme.backgroundBorder
        property color backgroundLightShadow: theme.backgroundLightShadow
        property color backgroundDarkShadow: theme.backgroundDarkShadow
        property color foreground: theme.foreground
        property color foregroundBorder: theme.foregroundBorder
        property color foregroundLightShadow: theme.foregroundLightShadow
        property color foregroundDarkShadow: theme.foregroundDarkShadow

        property color accent: theme.accent
        property color accentBorder: theme.accentBorder
        property color accentLightShadow: theme.accentLightShadow
        property color accentDarkShadow: theme.accentDarkShadow

        property color fontPrimary: theme.fontPrimary
        property color fontPrimaryBorder: theme.fontPrimaryBorder
        property color fontPrimaryLightShadow: theme.fontPrimaryLightShadow
        property color fontPrimaryDarkShadow: theme.fontPrimaryDarkShadow

        property color fontSecondary: theme.fontSecondary
        property color fontAccent: theme.fontAccent

        property QtObject devTheme: QtObject{
            property color background: "#B9B7BD"
            property color backgroundBorder: Qt.darker(background, 1.2)
            property color backgroundLightShadow: Qt.lighter(background, 1.8)
            property color backgroundDarkShadow: Qt.darker(background, 2.5)
            property color foreground: "#EEEDE7"
            property color foregroundBorder: Qt.darker(foreground, 1.2)
            property color foregroundLightShadow: Qt.lighter(foreground, 1.8)
            property color foregroundDarkShadow: Qt.darker(foreground, 1.5)

            property color accent: "#C44B4E"
            property color accentBorder: Qt.darker(accent, 1.2)
            property color accentLightShadow: Qt.lighter(accent, 1.8)
            property color accentDarkShadow: Qt.darker(accent, 3.0)

            property color fontPrimary: "#868B8E"
            property color fontPrimaryBorder: Qt.darker(fontPrimary, 1.2)
            property color fontPrimaryLightShadow: Qt.lighter(fontPrimary, 1.8)
            property color fontPrimaryDarkShadow: Qt.darker(fontPrimary, 2.5)

            property color fontSecondary: "#E7D2CC"
            property color fontAccent
        }

        property QtObject slateTheme: QtObject {
            property color background: "#83847E"
            property color backgroundBorder: Qt.darker(background, 1.2)
            property color backgroundLightShadow: Qt.lighter(background, 1.8)
            property color backgroundDarkShadow: Qt.darker(background, 2.5)
            property color foreground: "#DFDBE3"
            property color foregroundBorder: Qt.darker(foreground, 1.2)
            property color foregroundLightShadow: Qt.lighter(foreground, 1.8)
            property color foregroundDarkShadow: Qt.darker(foreground, 1.5)

            property color accent: "#C44B4E"
            property color accentBorder: Qt.darker(accent, 1.2)
            property color accentLightShadow: Qt.lighter(accent, 1.8)
            property color accentDarkShadow: Qt.darker(accent, 3.0)

            property color fontPrimary: "#2C2A26"
            property color fontPrimaryBorder: Qt.darker(fontPrimary, 1.2)
            property color fontPrimaryLightShadow: Qt.lighter(fontPrimary, 1.8)
            property color fontPrimaryDarkShadow: Qt.darker(fontPrimary, 2.5)

            property color fontSecondary: "#D9C6A3"
            property color fontAccent: "#FEC97C"
        }
    }
}










