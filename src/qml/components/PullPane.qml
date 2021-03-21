import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import QtPositioning 5.15

Rectangle {
    id: root
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    color: "lightsteelblue"

    property int minHeight: 150
    property int maxHeight: parent.height * 0.75
    height: minHeight
    //    property var place
    // temporary component for code completion
    Place {
        id: place
        name: "My Place!"
        location.address: Address {
            street: "123 My Street"
            city: "My City!"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill:parent
        // on clicked, parentheight += difference between mouse starting y
        // and current y
        property bool dragging: false
        property real lastY

        onPositionChanged: {
            if (    dragging
                    && root.maxHeight > root.height + (lastY - mouse.y)
                    && root.height + (lastY - mouse.y) > root.minHeight )
            {
                root.height += lastY - mouse.y
            }
        }

        onPressed: {
            lastY = mouse.y
            dragging = true
        }
        onReleased: dragging = false
    }

    Rectangle {
        id: imageRect
        height: 30
        width: 30
        radius: height / 2
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: markerImage
            anchors.centerIn: parent
            // TODO: source should be the place's icon
            //            source: "qrc://marker.png"
            source: "../resources/marker.png"
            scale: 0.4
        }
    }

    DropShadow {
        id: imageRectShadow
        anchors.fill: imageRect
        source: imageRect
        radius: 1.5
        samples: 9
        verticalOffset: 0.75
    }

    ColumnLayout {
        id: clipItem
        clip: true

        anchors.top: imageRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.topMargin: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.bottomMargin: 5

        spacing: 5

        // TODO:
        // If the section doesn't exist, the ColumnLayout.visible = false
        ColumnLayout {
            id: titleSection
            Layout.alignment: Qt.AlignHCenter
            //                anchors.top: parent.top
            //                anchors.right: parent.right
            //                anchors.left: parent.left
            spacing: 3

            Label {
                id: nameLabel;
                width: parent.width
                Layout.alignment: Qt.AlignHCenter

                text: place.name;
                font { family: "Arial"; bold: true }
            }

            Label {
                id: streetCityLabel
                width: parent.width
                Layout.alignment: Qt.AlignHCenter

                font { family: "Arial" }
                color: "grey"
                text: {
                    let t = ""

                    if (place.location.address.street
                            && place.location.address.city)
                    {
                        t += place.location.address.street + ", "
                        t += place.location.address.city
                    }
                    else if (place.location.address.street)
                        t += place.location.address.street;
                    else if (place.location.address.city)
                        t += place.location.address.city;

                    return t
                }
            }
        }

        ColumnLayout {
            id: contactSection
            Layout.alignment: Qt.AlignHCenter
            //                anchors.top: titleSection.bottom
            //                anchors.right: parent.right
            //                anchors.left: parent.left
            spacing: 10

            Rectangle {
                id: contactSectionSeparator
                implicitWidth: clipItem.width * 0.75
                height: 1.25
                color: "grey"
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                id: contactRow
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: {
                    contactSectionSeparator.implicitWidth - 20
                }

                Label {
                    id: contactPhone
                    //                        Layout.minimumWidth: 200
                    // TODO
                    text: "Phone here"
                    horizontalAlignment: Text.AlignHCenter
                }

                Item { Layout.fillWidth: true }

                Label {
                    id: contactWebsite
                    //                        Layout.minimumWidth: 200
                    // TODO
                    text: "Website here"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Item {id: filler; Layout.fillHeight: true }
    }


    /****************************************
  Footer
****************************************/

    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: navigateButton.implicitHeight
        //        {
        //            footerSeparator.height
        //            + navigateButton.height + navigateButton.anchors.topMargin
        //        }

        RoundButton {
            id: navigateButton
            anchors.centerIn: parent
            //            anchors.margins: 5

            radius: width / 8

            text: "Navigate"
        }
    }

    DropShadow {
        id: footerShadow
        anchors.fill: footer
        source: footer
        radius: 16
        samples: 32
        verticalOffset: 0.15
        spread: 0
    }
}
