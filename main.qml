import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

import "stats.js" as Stats

ApplicationWindow {
    id: mainwin
    visible: true
    width: 640
    height: 480
    title: "Project Stats"
    minimumWidth: 700
    maximumWidth: 700
    Component.onCompleted: { Stats.init(mainwin,selectDialog); }
    // HEADER PROPERTIES
    property alias header_filepath: statheader.header_filepath
    property alias header_active: statheader.header_active
    // FOOTER PROPERTIES
    property alias footer_text: statfooter.footer_text
    property alias footer_active: statfooter.footer_active
    // CONTENT PROPERTIES
    //
    //

    header: StatHeader { id: statheader }

    footer: StatFooter { id: statfooter }

    StatContent {}

    FileDialog {
        id: selectDialog
        title: "Choose the directory of the project:"
        visible: false
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        onAccepted: {
            mainwin.header_filepath = selectDialog.fileUrl;
            mainwin.footer_active = true;
        }
    }
}
