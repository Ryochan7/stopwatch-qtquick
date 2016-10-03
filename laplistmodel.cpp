#include <QDebug>
#include <QListIterator>

#include "laplistmodel.h"

LapListModel::LapListModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

int LapListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return m_items.size();
}

QVariant LapListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size())
    {
        return QVariant();
    }

    LapItem *val = m_items.at(index.row());

    switch (role) {
    case Qt::DisplayRole:
    case LapTimeRole:
        return QVariant::fromValue(val->getPassedMs());
    case LapDiffRole:
        return QVariant::fromValue(val->getDiffMs());
    case LapIndexRole:
        return QVariant::fromValue(index.row());
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LapListModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[LapTimeRole] = "lapTime";
    roles[LapDiffRole] = "diffTime";
    roles[LapIndexRole] = "lapIndex";

    return roles;
}

void LapListModel::clear()
{
    beginResetModel();

    QListIterator<LapItem*> iter(m_items);
    iter.toBack();
    while (iter.hasPrevious())
    {
        LapItem *temp = iter.previous();
        if (temp)
        {
            delete temp;
            temp = 0;
        }
    }

    m_items.clear();
    endResetModel();
}

void LapListModel::addLapItem(int passedMs)
{
    int index = m_items.size();
    beginInsertRows(QModelIndex(), index, index);
    LapItem *item = new LapItem(passedMs, this);
    m_items.append(item);
    if (index > 0)
    {
        int newdiff = passedMs - m_items.at(index-1)->getPassedMs();
        item->setDiffMs(newdiff);
    }

    endInsertRows();

}

bool LapListModel::canAddLapItem(int passedMs)
{
    bool result = false;
    if (passedMs <= this->m_timeLimit)
    {
        if (m_items.size() == 0)
        {
            result = true;
        }
        else if (m_items.size() > 0 &&
                 m_items.last()->getPassedMs() != this->m_timeLimit)
        {
            result = true;
        }
    }

    return result;
}
