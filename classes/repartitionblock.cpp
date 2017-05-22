#include "repartitionblock.h"

RepartitionBlock::RepartitionBlock(QQuickItem *parent) : QQuickPaintedItem(parent) { }

void RepartitionBlock::paint(QPainter *painter)
{
    painter->setCompositionMode(QPainter::CompositionMode_Source);
    painter->setRenderHint(QPainter::Antialiasing);
    painter->setPen(Qt::NoPen);
    double trdist = 0;
    if (m_valid) {
        for (int i=0;i<m_values.length();i++) {
            double w = width()*m_values[i];
            painter->fillRect(0,0,w,height(),QBrush(QColor(m_colors[i])));
            trdist += w;
            painter->translate(w,0);
        }
        painter->translate(-trdist,0);
    }
    else {
        painter->fillRect(1,1,width()-2,height()-2,QBrush(QColor("gray")));
        painter->setPen(QPen(QBrush(QColor("white")),3));
        painter->drawText(QRectF(0,0,width(),height()),Qt::AlignCenter,"?");
    }
    QPainterPath border;
    border.addRect(0,0,width(),height());
    border.addRoundedRect(0,0,width(),height(),7,7);
    painter->fillPath(border,Qt::transparent);
    painter->setBrush(Qt::NoBrush);
    painter->setPen(QPen(QBrush(QColor("silver")),2));
    painter->drawRoundedRect(1,1,width()-2,height()-2,7,7);
}

bool RepartitionBlock::getValid() { return m_valid; }

void RepartitionBlock::setValid(bool valid) { m_valid = valid; update(); }

QList<QString> RepartitionBlock::getColors() { return m_colors; }

void RepartitionBlock::setColors(QList<QString> colors) { m_colors = colors; }

QList<double> RepartitionBlock::getValues() { return m_values; }

void RepartitionBlock::setValues(QList<double> values) { m_values = values; update(); }
