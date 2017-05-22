#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "classes/repos.h"
#include "classes/repartitionblock.h"

int main(int argc, char *argv[])
{
    // init app
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("Project Stats");
    QCoreApplication::setApplicationVersion("0.1.0");
    QCoreApplication::setOrganizationName("Othy Software");

    // set new qml types
    qmlRegisterType<TypeGroup>("PStypes",1,0,"TypeGroup");
    qmlRegisterType<Repo>("PStypes",1,0,"Repo");
    qmlRegisterType<RepartitionBlock>("PStypes",1,0,"RepBlock");

    // init singletons
    Repos* repos = Repos::getInstance();

    // init engine
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("repos",repos);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // launch app
    return app.exec();
}
