import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3

import PStypes 1.0

import "stats.js" as Stats

Window {
    id: mainwin
    visible: true
    width: 650
    height: 480
    minimumWidth: 640
    minimumHeight: 480
    title: "Project Stats"
    property var localdb
    property bool onrun: false
    property color btnscol: "#0088ff"
    property int selidx
    Component.onCompleted: Stats.initSettings()
    Shortcut {
        sequence: StandardKey.Open
        enabled: !mainwin.onrun
        onActivated: selectDialog.open()
    }
    Shortcut {
        sequence: "Ctrl+R"
        enabled: (!mainwin.onrun && repos.count > 0)? true : false
        onActivated: Stats.run("all")
    }
    Shortcut {
        sequence: "Ctrl+Shift+R"
        enabled: (!mainwin.onrun && repos.count > 0)? true : false
        onActivated: Stats.run(repoListView.currentIndex)
    }
    Shortcut {
        sequence: "Ctrl+W" //StandardKey.Close (doesn't work on windows)
        enabled: (repoListView.currentIndex > -1)? true : false
        onActivated: { mainwin.selidx = repoListView.currentIndex; closeDiag.open() }
    }
    Shortcut {
        sequence: "Ctrl+?"
        onActivated: helpwin.show()
    }
    ListView {
        id: repoListView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: actionsZone.top
        anchors.margins: 0
        model: repos.list
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
            Rectangle {
                visible: running
                id: genIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                width: 22; height: 22; radius: 11
                border.color: "white"
                border.width: 1
                color: "#77ccff"
                RotationAnimator {
                    target: genIndicator
                    loops: Animation.Infinite
                    from: 0; to: 360; duration: 1000; running: repos.list[index].running
                }
                Text {
                    text: "\u21bb"
                    color: "white"
                    font.pointSize: 18
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Label {
                anchors.left: parent.left
                anchors.leftMargin: (running)? 30 : 10
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
                size: 22; text: "\u2192"
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: Stats.run(index)
            }
            CustomButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                size: 22; text: "\u2716"
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: { mainwin.selidx = index; closeDiag.open() }
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
                size: 30; text: "+"
                enabled: !mainwin.onrun
                onClicked: selectDialog.open()
            }
            CustomButton {
                size: 30; text: "\u21c9"
                enabled: (mainwin.onrun || repos.count == 0)? false : true
                onClicked: Stats.run("all")
            }
            CustomButton {
                size: 30; text: "?"
                onClicked: helpwin.show()
            }
        }
    }
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: repoListView.right
        anchors.margins: 0
        color: "white"
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 0
            width: 1
            color: "black"
        }
        Label {
            visible: repos.count == 0 ? true : false
            anchors.centerIn: parent
            font.pointSize: 20
            text: "No project available"
        }
        Label {
            id: projectTitle
            visible: repos.count == 0 ? false : true
            text: repos.list[repoListView.currentIndex].name
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.bold: true
            font.pointSize: 18
        }
        Label {
            id: projectPath
            visible: repos.count == 0 ? false : true
            text: repos.list[repoListView.currentIndex].url
            anchors.top: projectTitle.bottom
            anchors.topMargin: 7
            anchors.left: parent.left
            anchors.leftMargin: 20

        }
        CustomButton {
            size: 30; text: "\u2192"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.margins: 50
            onClicked: Stats.run(repoListView.currentIndex)
        }
        CustomButton {
            size: 30; text: "\u2716"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            onClicked: { mainwin.selidx = repoListView.currentIndex; closeDiag.open() }
        }
        TabBar {
            id: projectTabHead
            visible: repos.count == 0 ? false : true
            anchors.top: projectPath.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 0
            CustomTab { text: "Global" }
            CustomTab { text: "Headers" }
            CustomTab { text: "Sources" }
            CustomTab { text: "QML" }
            CustomTab { text: "JavaScript" }
        }
        StackLayout {
            visible: repos.count == 0 ? false : true
            anchors.top: projectTabHead.bottom
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            currentIndex: projectTabHead.currentIndex
            Item {
                id: projectGlobal
                Column {
                    spacing: 3
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 0
                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 0
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Files repartition:"
                            width: 140
                        }
                        RepBlock {
                            valid: repos.list[repoListView.currentIndex].parsed
                            colors: ["crimson","steelblue","lime","gold"]
                            values: repos.list[repoListView.currentIndex].filesRepartition
                            width: parent.width-143
                            height: 25
                        }
                    }
                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 0
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Lines repartition:"
                            width: 140
                        }
                        RepBlock {
                            //
                            valid: false
                            //
                            width: parent.width-143
                            height: 24
                            //
                        }
                    }
                    Row {
                        //
                        //
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Types:"
                            width: 140
                        }
                    }
                }
            }
            Item {
                Label {
                    visible: !repos.list[repoListView.currentIndex].parsed
                    text: "Run stats generation for this project"
                    font.italic: true
                }
                Label {
                    //
                    visible: repos.list[repoListView.currentIndex].parsed
                    text: "There is no header files in this project"
                    //
                }
                Column {
                    //
                    visible: repos.list[repoListView.currentIndex].parsed
                    //
                }
            }
            Item {
                //
                //
                Label {
                    visible: !repos.list[repoListView.currentIndex].parsed
                    text: "Run stats generation for this project"
                    font.italic: true
                }
                Label { text: "item 3" }
            }
            Item {
                //
                //
                Label {
                    visible: !repos.list[repoListView.currentIndex].parsed
                    text: "Run stats generation for this project"
                    font.italic: true
                }
                Label { text: "item 4" }
            }
            Item {
                //
                //
                Label {
                    visible: !repos.list[repoListView.currentIndex].parsed
                    text: "Run stats generation for this project"
                    font.italic: true
                }
                Label { text: "item 5" }
            }
        }
    }
    FileDialog {
        id: selectDialog
        title: "Choose the project:"
        visible: false
        selectMultiple: false
        selectExisting: true
        selectFolder: false
        folder: shortcuts.home
        nameFilters: ["Project file (*.pro)"]
        onAccepted: Stats.addRepo(selectDialog.fileUrl)
    }
    Dialog {
        id: existDialog
        visible: false
        title: "Project already listed!"
        standardButtons: Dialog.Ok
        Label {
            text: "This project is already listed!"
            anchors.centerIn: parent
        }
    }
    Dialog {
        id: closeDiag
        visible: false
        title: "Remove a project"
        width: 250
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: Stats.remRepo(mainwin.selidx)
        Label {
            text: "Do you really want to remove '"+repos.list[repoListView.currentIndex].name+"'?"
        }
    }
    Window {
        id: helpwin
        visible: false
        modality: Qt.ApplicationModal
        width: 600
        height: 500
        minimumWidth: helpwin.width
        maximumWidth: helpwin.width
        minimumHeight: helpwin.height
        maximumHeight: helpwin.height
        Label {
            id: helpTitle
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 20
            font.bold: true
            text: "Help window"
        }
        ListView {
            id: helpListView
            anchors.top: helpTitle.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 20
            width: 120
            clip: true
            interactive: false
            model: ListModel {
                ListElement { title: "Shortcuts" }
                ListElement { title: "Bar" }
                ListElement { title: "Side List" }
                //ListElement { title: "Infos" }
            }
            delegate: Item {
                width: helpListView.width
                height: 30
                property bool hover: false
                Rectangle {
                    anchors.fill: parent
                    color: (helpListView.currentIndex == index)? "#0088ff" : (parent.hover ? "#77ccff" : "white")
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: (helpListView.currentIndex == index)? "white" : "black"
                    text: title
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hover = true
                    onExited: parent.hover = false
                    onClicked: {
                        helpListView.currentIndex = index
                        var item
                        switch (title) {
                        case "Shortcuts": item = shortcutsHelp; break
                        case "Bar": item = barHelp; break
                        case "Side List": item = listHelp; break
                        case "Infos": item = infosHelp; break
                        }
                        helpStack.replace(item)
                    }
                }
            }
        }
        StackView {
            id: helpStack
            anchors.top: helpTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: helpListView.right
            anchors.right: parent.right
            anchors.margins: 20
            initialItem: shortcutsHelp
            Transition {
                id: enterAnim
                YAnimator { from: helpStack.height; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
            Transition {
                id: exitAnim
                YAnimator { from: 0; to: helpStack.height; duration: 300; easing.type: Easing.OutCubic }
            }
            replaceEnter: enterAnim; replaceExit: exitAnim
            Item {
                id: shortcutsHelp
                visible: false
                Label {
                    id: shortcutsHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Shortcuts:"
                }
                ListView {
                    id: shortcutsHelpList
                    anchors.top: shortcutsHelpTitle.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    clip: true
                    interactive: false
                    model: ListModel {
                        ListElement { desc: "Add a project:"; cmd: "Ctrl+O" }
                        ListElement { desc: "Run the generation for all projects:"; cmd: "Ctrl+R" }
                        ListElement { desc: "Run the generation for the selected project:"; cmd: "Ctrl+Shift+R" }
                        ListElement { desc: "Remove the selected project from the list:"; cmd: "Ctrl+W" }
                        ListElement { desc: "Show the help:"; cmd: "Ctrl+?" }
                    }
                    delegate: Item {
                        width: shortcutsHelpList.width
                        height: 25
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 10
                            text: desc
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.margins: 10
                            horizontalAlignment: Text.AlignRight
                            text: cmd
                        }
                    }
                }
            }
            Item {
                id: barHelp
                visible: false
                Label {
                    id: barHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Bar:"
                }
                Row {
                    anchors.top: barHelpTitle.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15
                    Column {
                        spacing: 10
                        width: 100
                        CustomButton { size: 30; text: "+" }
                        Label {
                            text: "Add a\nproject"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column {
                        spacing: 10
                        width: 100
                        CustomButton { size: 30; text: "\u21c9" }
                        Label {
                            text: "Run for all\nproject"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column {
                        spacing: 10
                        width: 100
                        CustomButton { size: 30; text: "?" }
                        Label {
                            text: "Show help"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
            Item {
                id: listHelp
                visible: false
                Label {
                    id: listHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "List:"
                }
                Column {
                    spacing: 10
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            width: 180; height: 30
                            color: "#0088ff"
                            CustomButton {
                                size: 22
                                text: "\u21bb"
                                enabled: false
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                text: "Project Stats"
                            }
                            CustomButton {
                                size: 22
                                text: "\u2192"
                                reversed: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 32
                            }
                            CustomButton {
                                size: 22
                                text: "\u2716"
                                reversed: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Selected project"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            width: 180; height: 30
                            color: "white"
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: "black"
                                text: "Project Stats"
                            }
                            CustomButton {
                                size: 22
                                text: "\u2192"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 32
                            }
                            CustomButton {
                                size: 22
                                text: "\u2716"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Unselected project"
                        }
                    }
                    Row {
                        height: 30
                        Rectangle { color: "white"; height: 30; width: 100 }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        CustomButton {
                            size: 22
                            text: "\u21bb"
                            enabled: false
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Generation in progress indicator"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        CustomButton {
                            size: 22
                            text: "\u2192"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Run the generation for the project"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        CustomButton {
                            size: 22
                            text: "\u2716"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Remove the project from the list"
                        }
                    }
                }
            }
            Item {
                id: infosHelp
                visible: false
                Label {
                    id: infosHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Infos:"
                }
                //
                //
            }
        }
    }
}
