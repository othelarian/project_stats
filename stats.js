
function createdb(db) {
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE repos (name TEXT,url TEXT);")
    })
    db.changeVersion("","1.0")
}

function initSettings() {
    mainwin.localdb = LocalStorage.openDatabaseSync("project_stats_db","1.0","",200000,createdb)
    mainwin.localdb.transaction(function(tx) {
        var rs = tx.executeSql("SELECT * FROM repos ORDER BY name;")
        for (var i=0;i<rs.rows.length;i++) {
            repoModel.append({ name: rs.rows.item(i).name, url: rs.rows.item(i).url })
        }
    })
}

function insertRepo(name,url) {
    //
    //
}

function addRepo(url) {
    var name = url.toString().substring(url.toString().lastIndexOf("/")+1)
    var inc = false
    for (var i=0;i<repoModel.count;i++) {
        if (repoModel.get(i).name > name) {
            repoModel.insert(i,{name: name, url: url.toString()})
            inc = true
            break
        }
    }
    if (!inc) { repoModel.append({name: name, url: url.toString()}) }
    mainwin.localdb.transaction(function(tx) {
        tx.executeSql("INSERT INTO repos VALUES(?,?);",[name,url.toString()])
    })
}

function remRepo(idx) {
    //
    console.log("close a repo")
    //
}

function run(chx) {
    // disable controls
    mainwin.onrun = true
    //
    // TODO : list the fole in the directory
    // TODO : look for the extension
    // TODO : for each file, parse it
    //
    //
    console.log("run !");
    //
    //
    // reenable controls
    //mainwin.onrun = false
}

function generate(idx) {
    //
    //
}
