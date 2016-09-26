#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "laplistmodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    LapListModel testModel;
    engine.rootContext()->setContextProperty("testModel", &testModel);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

