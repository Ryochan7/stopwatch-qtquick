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

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void clear();
    Q_INVOKABLE void addLapItem(int passedMs);

protected:
    QList<LapItem*> m_items;

signals:

public slots:
};

#endif // LAPLISTMODEL_H
