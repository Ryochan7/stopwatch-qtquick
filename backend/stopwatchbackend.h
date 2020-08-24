#ifndef STOPWATCHBACKEND_H
#define STOPWATCHBACKEND_H

#include <QObject>

#include "laplistmodel.h"

class StopWatchBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(LapListModel *lapListModel MEMBER listModel CONSTANT)
public:
    explicit StopWatchBackend(QObject *parent = nullptr);

private:
    LapListModel *listModel;

signals:

public slots:
};

#endif // STOPWATCHBACKEND_H
