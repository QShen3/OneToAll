#include <QGuiApplication>
#include <QQuickWindow>
#include <QDebug>
#import <UIKit/UIKit.h>

#include "UIButton.h"

QUIButton::QUIButton(QQuickItem *parent) : QQuickItem(parent)
{
    m_UIButton = NULL;
}

QUIButton::~QUIButton()
{

}

void QUIButton::componentComplete()
{
    QQuickItem::componentComplete();
    if(m_UIButton == NULL){
        UIView *mainView = reinterpret_cast<UIView*>(this->window()->winId());
        m_UIButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect btn2Frame = CGRectMake(10.0, 10.0, 60.0, 44.0);
        [m_UIButton setFrame:btn2Frame];
        [m_UIButton setTitle:@"BTN1" forState:UIControlStateNormal];
        [mainView addSubview:(UIButton*)m_UIButton];
    }
}
