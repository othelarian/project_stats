
function createdb(db) {
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE repos (name TEXT,url TEXT);")
    })
    db.changeVersion("","1.0")
}

function initSettings() {
    mainwin.localdb = LocalStorage.openDatabaseSync("project_stats_db","1.0","",200000,createdb)
    mainwin.localdb.transaction(function(tx) {
        var rs = tx.executeSql("SELECT * FROM repos;")
        for (var i=0;i<rs.rows.length;i++) {
            var valid = repos.addRepo(rs.rows.item(i).name,rs.rows.item(i).url)
            if (!valid) {
                var args = [rs.rows.item(i).name,rs.rows.item(i).url]
                tx.executeSql("DELETE FROM repos WHERE name=? AND url=?;",args)
            }
        }
    })
}

function addRepo(url) {
    var exist = false;
    mainwin.localdb.transaction(function(tx) {
        var rs = tx.executeSql("SELECT COUNT(*) AS count FROM repos WHERE url=?;",[url.toString()])
        if (rs.rows.item(0).count > 0) { exist = true }
    })
    if (exist) {
        existDialog.open()
        return
    }
    var name = url.toString().substring(url.toString().lastIndexOf("/")+1)
    name = name.split(".")[0]
    var valid = repos.addRepo(name,url.toString())
    if (valid) {
        mainwin.localdb.transaction(function(tx) {
            tx.executeSql("INSERT INTO repos VALUES(?,?);",[name,url.toString()])
        })
    }
}

function remRepo(idx) {
    mainwin.localdb.transaction(function(tx) {
        var args = [repos.list[idx].name,repos.list[idx].url]
        tx.executeSql("DELETE FROM repos WHERE name=? AND url=?;",args)
    })
    repos.remRepo(idx)
}

function run(chx) {
    mainwin.onrun = true
    if (chx == "all") {
        console.log("generate for all project")
        for (var i=0;i<repos.count;i++) {
            var res = repos.list[i].generate()
            if (!res) { remRepo(i); i-- }
        }
    }
    else {
        repoListView.currentIndex = chx
        var res = repos.list[chx].generate()
        if (!res) { remRepo(chx) }
    }
    mainwin.onrun = false
}
