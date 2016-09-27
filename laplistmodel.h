#ifndef LAPLISTMODEL_H
#define LAPLISTMODEL_H

#include <QObject>
#include <QList>
#include <QHash>
#include <QAbstractListModel>

#include "lapitem.h"

class LapListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum LapItemRoles {
        LapTimeRole = Qt::UserRole + 1,
        LapDiffRole,
        LapIndexRole,
    };

    Q_ENUM(LapItemRoles)

    explicit LapListModel(QObject *parent = 0);

    Q_PROPERTY(int timeLimt MEMBER timeLimit CONSTANT)

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void clear();
    Q_INVOKABLE void addLapItem(int passedMs);
    Q_INVOKABLE bool canAddLapItem(int passedMs);

    static const int timeLimit = 600000;

protected:
    QList<LapItem*> m_items;

signals:

public slots:
};

#endif // LAPLISTMODEL_H
