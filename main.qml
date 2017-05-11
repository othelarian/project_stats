import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0

import "stats.js" as Stats

Window {
    id: mainwin
    visible: true
    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480
    title: "Project Stats"
    property var localdb
    property bool onrun: false
    property color btnscol: "#0088ff"
    Component.onCompleted: Stats.initSettings()
    Shortcut {
        sequence: StandardKey.Open
        enabled: !mainwin.onrun
        onActivated: selectDialog.open()
    }
    Shortcut {
        sequence: "Ctrl+R"
        enabled: (!mainwin.onrun && repoModel.count > 0)? true : false
        onActivated: Stats.run("all")
    }
    Shortcut {
        sequence: StandardKey.Close
        enabled: (repoListView.currentIndex > -1)? true : false
        onActivated: Stats.remRepo(repoListView.currentIndex)
    }
    ListModel { id: repoModel }
    ListView {
        id: repoListView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: actionsZone.top
        anchors.margins: 0
        model: repoModel
        width: 240
        delegate: Item {
            height: 30
            width: repoListView.width
            clip: true
            property bool hover: false
            Rectangle {
                id: repoBack
                anchors.fill: parent
                color: (repoListView.currentIndex == index)? "#0088ff" : (parent.hover ? "#77ccff" : "white")
            }
            Label {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                color: (repoListView.currentIndex == index)? "white" : "black"
                text: name
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hover = true
                onExited: parent.hover = false
                onClicked: repoListView.currentIndex = index
            }
            CustomButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 32
                width: 22; height: 22
                text: ">"
                hoverEnabled: true
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: Stats.run(index)
            }
            CustomButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                width: 22; height: 22
                text: "x"
                hoverEnabled: true
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: Stats.remRepo(index)
            }
        }
    }
    Rectangle {
        id: actionsZone
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: repoListView.width
        height: 40
        color: "white"
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 0
            height: 1
            color: "black"
        }
        Row {
            anchors.centerIn: parent
            spacing: 20
            CustomButton {
                width: 30; height: 30
                enabled: !mainwin.onrun
                text: "+"
                onClicked: selectDialog.open()
            }
            CustomButton {
                width: 30; height: 30
                enabled: (mainwin.onrun || repoModel.count == 0)? false : true
                text: ">"
                onClicked: Stats.run("all")
            }
        }
    }
    Rectangle {
        //
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: repoListView.right
        anchors.margins: 0
        //
        color: "white"
        //
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 0
            width: 1
            color: "black"
        }
        //
        Label {
            //
            text: repoListView.currentIndex
            //
        }
        //
        // TODO : interface
        //
    }
    FileDialog {
        id: selectDialog
        title: "Choose the directory of the project:"
        visible: false
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        folder: shortcuts.home
        onAccepted: Stats.addRepo(selectDialog.fileUrl)
    }
}
