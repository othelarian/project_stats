import QtQuick 2.0
import QtQuick.Controls 2.0

import "stats.js" as Stats

Rectangle {
    id: statfooter
    height: 30
    width: 700
    color: "grey"
    property string footer_text: "Ready to go"
    property bool footer_active: false

    Text {
        text: statfooter.footer_text;
        width: 500
        wrapMode: Text.WrapAnywhere
        maximumLineCount: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
    }

    Button {
        text: "Run"
        height: 26
        width: 50
        enabled: statfooter.footer_active
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 80
        onClicked: { Stats.run(); }
    }
}
