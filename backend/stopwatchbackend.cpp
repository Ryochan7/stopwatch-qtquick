//#include <QDebug>

#include "stopwatchbackend.h"

StopWatchBackend::StopWatchBackend(QObject *parent) : QObject(parent)
{
    listModel = new LapListModel(this);
}
