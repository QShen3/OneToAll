#ifndef SETTINGS
#define SETTINGS
#include <QObject>

class QSettings;

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool autoCheckNewVersion READ isAutoCheckNewVersion WRITE setAutoCheckNewVersion NOTIFY autoCheckNewVersionChanged)
    Q_PROPERTY(bool firstStart READ isFirstStart WRITE setFirstStart NOTIFY firstStartChanged)
public:
    explicit Settings(QObject *parent = 0);
    ~Settings();
    bool isAutoCheckNewVersion();
    bool isFirstStart();

    void setAutoCheckNewVersion(bool);
    void setFirstStart(bool);

signals:
    void autoCheckNewVersionChanged();
    void firstStartChanged();

public slots:
    void loadSettings();
    void saveSettings();
    void clear();
private:
    QSettings *settings;
    bool m_autoCheckNewVersion;
    bool m_firstStart;
};
#endif // SETTINGS

