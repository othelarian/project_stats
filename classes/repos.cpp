#include "repos.h"

#include <QDebug>

// REPO #############################

Repo::Repo(QObject *parent) : QObject(parent) { }

Repo::Repo(QString name, QString url, QObject *parent) : QObject(parent)
{
    m_name = name;
    m_url = url;
    m_running = false;
    //
}

bool Repo::generate()
{
    m_running = true;
    emit repoChanged();
    if (!QFile(QUrl(m_url).toLocalFile()).exists()) { return false; }
    QDir folder(QUrl(m_url.remove(m_url.lastIndexOf("/")+1,m_url.length()-m_url.lastIndexOf("/"))).toLocalFile());
    m_headers.clear();
    m_sources.clear();
    m_qml.clear();
    m_js.clear();
    readDir(folder,"");
    //
    //
    qInfo() << "headers:";
    for (int i=0;i<m_headers.length();i++) { qInfo() << m_headers.at(i); }
    qInfo() << "sources:";
    for (int i=0;i<m_sources.length();i++) { qInfo() << m_sources.at(i); }
    qInfo() << "qml:";
    for (int i=0;i<m_qml.length();i++) qInfo() << m_qml.at(i);
    qInfo() << "js:";
    for (int i=0;i<m_js.length();i++) qInfo() << m_js.at(i);
    //
    //
    m_running = false;
    emit repoChanged();
    return true;
}

QString Repo::getName() { return m_name; }

QString Repo::getUrl() { return m_url; }

bool Repo::getRun() { return m_running; }

int Repo::getNbFiles() { return m_headers.length()+m_sources.length()+m_qml.length()+m_js.length(); }

// private methods

void Repo::readDir(QDir folder, QString path)
{
    QDir tmp(folder.absolutePath()+path);
    tmp.setFilter(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Files);
    tmp.setSorting(QDir::DirsFirst | QDir::Name);
    QFileInfoList entries_list = tmp.entryInfoList();
    for (int i=0;i<entries_list.length();i++) {
        QFileInfo entry = entries_list.at(i);
        if (entry.isDir()) { readDir(folder,path+"/"+entry.fileName()); }
        else {
            QString ext = entry.completeSuffix();
            if (ext == "h" || ext == "hpp") { m_headers.append(path+"/"+entry.fileName()); }
            else if (ext == "c" || ext == "cpp" || ext == "cc") { m_sources.append(path+"/"+entry.fileName()); }
            else if (ext == "qml") { m_qml.append(path+"/"+entry.fileName()); }
            else if (ext == "js") { m_js.append(path+"/"+entry.fileName()); }
        }
    }
}

// REPOS ############################

Repos* Repos::m_instance = nullptr;

Repos::Repos() { }

Repos* Repos::getInstance()
{
    if (m_instance == nullptr) m_instance = new Repos();
    return m_instance;
}

QQmlListProperty<Repo> Repos::getList() { return QQmlListProperty<Repo>(this,m_repos); }

int Repos::count() { return m_repos.length(); }

bool Repos::addRepo(QString name, QString url)
{
    if (!QFile(QUrl(url).toLocalFile()).exists()) { return false; }
    Repo* newrepo = new Repo(name,url);
    bool inc = false;
    for (int i=0;i<m_repos.length();i++) {
        if (m_repos[i]->getName() > name) {
            m_repos.insert(i,newrepo);
            inc = true;
            break;
        }
    }
    if (!inc) { m_repos.append(newrepo); }
    emit reposListChanged();
    return true;
}

void Repos::remRepo(int idx)
{
    m_repos.removeAt(idx);
    emit reposListChanged();
}
