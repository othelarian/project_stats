#ifndef REPOS_H
#define REPOS_H

#include <QObject>
#include <QList>
#include <QQmlListProperty>

class Repo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName NOTIFY repoChanged)
    Q_PROPERTY(QString url READ getUrl NOTIFY repoChanged)
public:
    Repo(QObject *parent = 0);
    Repo(QString name, QString url, QObject *parent = 0);
    //
    Q_INVOKABLE void generate();
    //
    QString getName();
    QString getUrl();
    //
private:
    QString m_name;
    QString m_url;
    //
    //
signals:
    void repoChanged();
};

class Repos : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Repo> list READ getList NOTIFY reposListChanged)
    Q_PROPERTY(int count READ count NOTIFY reposListChanged)
public:
    static Repos* getInstance();
    Q_INVOKABLE QQmlListProperty<Repo> getList();
    int count();
    Q_INVOKABLE bool addRepo(QString name, QString url);
    Q_INVOKABLE void remRepo(int idx);
private:
    Repos();
    static Repos* m_instance;
    QList<Repo*> m_repos;
signals:
    void reposListChanged();
};

#endif // REPOS_H
