#include <QSettings>
#include <QDebug>
#include "Settings.h"

Settings::Settings(QObject *parent) : QObject(parent),settings(NULL)
{
    settings = new QSettings(QSettings::IniFormat,QSettings::UserScope,"QShen","OneToAll",this);
    loadSettings();
}

Settings::~Settings()
{
    saveSettings();
}

void Settings::loadSettings()
{
    qDebug() << "Loading settings...";
    if (settings){
        m_autoCheckNewVersion = settings->value("autoCheckNewVersion", true).toBool();
    }
    else qDebug() << "settings load failed...";
}

void Settings::saveSettings()
{
    qDebug() << "Saving settins...";
    if (settings){
        settings->setValue("autoCheckNewVersion", m_autoCheckNewVersion);
    }
    else qDebug() << "settings save failed...";
}

void Settings::clear()
{
    if (settings){
        settings->clear();
        loadSettings();
    }
}

bool Settings::isAutoCheckNewVersion()
{
    return m_autoCheckNewVersion;
}
bool Settings::isFirstStart()
{
    return m_firstStart;
}

void Settings::setAutoCheckNewVersion(bool arg)
{
    if (m_autoCheckNewVersion != arg){
        m_autoCheckNewVersion = arg;
        emit autoCheckNewVersionChanged();
    }
}
void Settings::setFirstStart(bool arg)
{
    if(m_firstStart != arg){
        m_firstStart = arg;
        emit firstStartChanged();
    }
}
