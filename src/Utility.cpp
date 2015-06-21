#include "Utility.h"
Utility::Utility(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID

#ifdef Q_PROCESSOR_X86
    m_platformType = Andriod_x86;
#else
    m_platformType = Andriod_armv7;
#endif

#endif
}
Utility::~Utility()
{

}

Utility::PlatformType Utility::platformType() const
{
    return m_platformType;
}
