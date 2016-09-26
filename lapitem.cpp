#include "lapitem.h"

LapItem::LapItem(int passedMs, QObject *parent) : QObject(parent)
{
    m_passedMs = passedMs;
    m_diffMs = 0;
}

int LapItem::getPassedMs()
{
    return m_passedMs;
}

void LapItem::setPassedMs(int passedMs)
{
    if (this->m_passedMs != passedMs)
    {
        this->m_passedMs = passedMs;
        emit passedMsChanged(passedMs);
    }
}

int LapItem::getDiffMs()
{
    return m_diffMs;
}

void LapItem::setDiffMs(int diffMs)
{
    if (this->m_diffMs != diffMs)
    {
        this->m_diffMs = diffMs;
        emit diffMsChanged(diffMs);
    }
}
