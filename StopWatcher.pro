TEMPLATE = app

QT += qml quick quickcontrols2

CONFIG += c++11

SOURCES += main.cpp \
    backend/stopwatchbackend.cpp \
    laplistmodel.cpp \
    lapitem.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

# Include project for using QQmlSortFilterProxyModel.
include($$(HOME)/Sources/SortFilterProxyModel/SortFilterProxyModel.pri)

HEADERS += \
    backend/stopwatchbackend.h \
    constants.h \
    laplistmodel.h \
    lapitem.h

