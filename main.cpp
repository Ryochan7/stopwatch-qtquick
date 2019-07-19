#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "laplistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    LapListModel testModel;
    engine.rootContext()->setContextProperty("testModel", &testModel);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

