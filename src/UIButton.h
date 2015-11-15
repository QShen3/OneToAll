#ifndef UIBUTTON
#define UIBUTTON

#include <QQuickItem>

class QUIButton : public QQuickItem
{
    Q_OBJECT

public:
    explicit QUIButton(QQuickItem *parent = 0);
    ~QUIButton();

protected:
    virtual void componentComplete();

private:
    void *m_UIButton;
};

#endif // UIBUTTON

