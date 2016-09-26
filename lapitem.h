#ifndef LAPITEM_H
#define LAPITEM_H

#include <QObject>

class LapItem : public QObject
{
    Q_OBJECT
public:
    explicit LapItem(int passedMs, QObject *parent = 0);

    Q_PROPERTY(int passedMs READ getPassedMs WRITE setPassedMs NOTIFY passedMsChanged)
    Q_PROPERTY(int diffMs READ getDiffMs WRITE setDiffMs NOTIFY diffMsChanged)

    int getPassedMs();
    void setPassedMs(int passedMs);

    int getDiffMs();
    void setDiffMs(int diffMs);

protected:
    int m_passedMs;
    int m_diffMs;

signals:
    void passedMsChanged(int value);
    void diffMsChanged(int value);

public slots:
};

#endif // LAPITEM_H
