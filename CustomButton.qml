import QtQuick 2.7
import QtQuick.Controls 2.1

RoundButton {
    id: customButton
    property bool reversed: false
    contentItem: Text {
        text: customButton.text
        font.pointSize: 18
        color: customButton.enabled ? (customButton.reversed ? "black" : "white") : "gray"
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 40
        color: customButton.enabled ? (customButton.down ? "#0044aa" : ( customButton.reversed ? "white" : "#0088ff")) : "#77ccff"
        border.color: customButton.hovered ? "black" : "white"
        border.width: 1
        radius: width/2
    }
}
