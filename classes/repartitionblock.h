#ifndef REPARTITIONBLOCK_H
#define REPARTITIONBLOCK_H

#include <QBrush>
#include <QPainter>
#include <QPainterPath>
#include <QQuickItem>
#include <QQmlListProperty>
#include <QQuickPaintedItem>
#include <QList>

class RepartitionBlock : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(bool valid READ getValid WRITE setValid NOTIFY repBlockChanged)
    Q_PROPERTY(QList<QString> colors READ getColors WRITE setColors NOTIFY repBlockChanged)
    Q_PROPERTY(QList<double> values READ getValues WRITE setValues NOTIFY repBlockChanged)
public:
    RepartitionBlock(QQuickItem *parent = 0);
    void paint(QPainter *painter);
    bool getValid();
    void setValid(bool valid);
    QList<QString> getColors();
    void setColors(QList<QString> colors);
    QList<double> getValues();
    void setValues(QList<double> values);
private:
    bool m_valid;
    QList<QString> m_colors;
    QList<double> m_values;
signals:
    repBlockChanged();
};

#endif // REPARTITIONBLOCK_H
