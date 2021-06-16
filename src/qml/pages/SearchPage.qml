import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
//import com.mkerr.navi 1.0
import ".."

Pane {
    id: root
    padding: 0

    //    property alias header: headerRect
    property var bgColor
    property bool night

//    SearchPageImpl {}

    HotReloader {
        property var bgColor: root.bgColor
        property bool night: root.night
        source: "pages/SearchPageImpl.qml"
    }
}
