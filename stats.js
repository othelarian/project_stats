.pragma library

var mainwin;
var selectDialog;

function init(root,dialog) {
    mainwin = root;
    selectDialog = dialog;
}

function select() { selectDialog.open(); }

function run() {
    // DISABLE CONTROLS
    mainwin.footer_text = "In progress...";
    mainwin.footer_active = false;
    mainwin.header_active = false;
    // PARSE PROJECT
    //
    // TODO : list the fole in the directory
    // TODO : look for the extension
    // TODO : for each file, parse it
    //
    //
    console.log("run !");
    //
    //
    // ENABLE CONTROLS
    mainwin.footer_text = "Ready to go";
    mainwin.footer_active = true;
    mainwin.header_active = true;
}
