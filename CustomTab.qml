import QtQuick 2.7
import QtQuick.Controls 2.1

TabButton {
    id: customTab
    width: 70
    hoverEnabled: true
    contentItem: Text {
        text: customTab.text
        font.pointSize: 10
        color: customTab.checked ? "black" : "white"
    }
    background: Rectangle {
        implicitWidth: 80
        implicitHeight: 20
        border.color: customTab.checked ? "black" : "white"
        border.width: 1
        color: customTab.checked ? "white" : "#0088ff"
    }
}
