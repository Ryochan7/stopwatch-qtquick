#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "constants.h"
#include "backend/stopwatchbackend.h"

void RegisterClassesForQML()
{
    qmlRegisterType<StopWatchBackend>(ProjectConstants::packageId,
                                      ProjectConstants::packageVersionMajor, ProjectConstants::packageVersionMinor,
                                      "StopWatchBackend");

    qRegisterMetaType<LapListModel*>("LapListModel*");
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    RegisterClassesForQML();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

