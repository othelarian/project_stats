import QtQuick 2.0
import QtQuick.Controls 2.0

import "stats.js" as Stats

Rectangle {
    id: statheader
    height: 30
    width: 700
    color: "grey"
    property string header_filepath: ""
    property bool header_active: true

    Rectangle {
        color: "white"
        height: 26
        width: 500
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 2

        Text {
            text: statheader.header_filepath
            width: 494
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 2
        }
    }

    Button {
        id: statheader_search
        text: "Select"
        height: 26
        width: 80
        enabled: statheader.header_active
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 80
        onClicked: { Stats.select(); }
    }
}
