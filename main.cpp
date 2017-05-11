#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QQmlContext>

int main(int argc, char *argv[])
{
    // init app
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("Project Stats");
    QCoreApplication::setApplicationVersion("0.1.0");
    QCoreApplication::setOrganizationName("Othy Software");

    // init engine
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // launch app
    return app.exec();
}
