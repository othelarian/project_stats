#ifndef REPOS_H
#define REPOS_H

#include <QObject>
#include <QList>
#include <QQmlListProperty>
#include <QDir>
#include <QList>
//#include <QHash>
#include <QMap>

class TypeGroup : public QObject
{
    Q_OBJECT
    //
    //
public:
    TypeGroup(QObject *parent = 0);
    //TypeGroup
    //
    void clear();
    void append(QString name);
    int length();
    QString at(int index);
    //
private:
    //
    //QHash<QString,int[3]> m_files;
    QMap<QString,QList<int>> m_files;
    //
};

class Repo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName NOTIFY repoChanged)
    Q_PROPERTY(QString url READ getUrl NOTIFY repoChanged)
    Q_PROPERTY(bool running READ getRun NOTIFY repoRunning)
    Q_PROPERTY(int nbFiles READ getNbFiles NOTIFY repoParsed)
    Q_PROPERTY(bool parsed READ getParsed NOTIFY repoParsed)
    Q_PROPERTY(QList<double> filesRepartition READ getFilesRepartition NOTIFY repoParsed)
    //
    //Q_PROPERTY(TypeGroup headers READ getHeaders NOTIFY repoParsed)
    //Q_PROPERTY(TypeGroup sources READ getSources NOTIFY repoParsed)
    //Q_PROPERTY(TypeGroup qml READ getQml NOTIFY repoParsed)
    //Q_PROPERTY(TypeGroup js READ getJs NOTIFY repoParsed)
    //
public:
    Repo(QObject *parent = 0);
    Repo(QString name, QString url, QObject *parent = 0);
    Q_INVOKABLE bool generate();
    QString getName();
    QString getUrl();
    bool getRun();
    int getNbFiles();
    bool getParsed();
    QList<double> getFilesRepartition();
    //
    TypeGroup getHeaders();
    //TypeGroup getSources();
    //TypeGroup getQml();
    //TypeGroup getJs();
    //
private:
    void readDir(QDir folder, QString path);
    QString m_name;
    QString m_url;
    bool m_parsed;
    bool m_running;
    //
    //QList<QString> m_headers;
    //QList<QString> m_sources;
    //QList<QString> m_qml;
    //QList<QString> m_js;
    //
    TypeGroup* m_headers;
    TypeGroup* m_sources;
    TypeGroup* m_qml;
    TypeGroup* m_js;
    //
signals:
    void repoChanged();
    void repoRunning();
    void repoParsed();
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
