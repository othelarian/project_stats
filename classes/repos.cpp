#include "repos.h"

#include <QDebug>

// REPO #############################

Repo::Repo(QObject *parent) : QObject(parent) { }

Repo::Repo(QString name, QString url, QObject *parent) : QObject(parent)
{
    //
    m_name = name;
    m_url = url;
    //
}

void Repo::generate()
{
    //
    // TODO : calculate the stats of the repo
    //
    qInfo() << "generate for: " << m_name;
    //
    emit repoChanged();
}

QString Repo::getName() { return m_name; }

QString Repo::getUrl() { return m_url; }

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
