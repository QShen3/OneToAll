#ifndef SETTINGS
#define SETTINGS
#include <QObject>

class QSettings;

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool autoCheckNewVersion READ isAutoCheckNewVersion WRITE setAutoCheckNewVersion NOTIFY autoCheckNewVersionChanged)
    Q_PROPERTY(int versionCode READ versionCode WRITE setVersionCode NOTIFY versionCodeChanged)
public:
    explicit Settings(QObject *parent = 0);
    ~Settings();
    bool isAutoCheckNewVersion();
    int versionCode();

    void setAutoCheckNewVersion(bool);
    void setVersionCode(int);

signals:
    void autoCheckNewVersionChanged();
    void versionCodeChanged();

public slots:
    void loadSettings();
    void saveSettings();
    void clear();
private:
    QSettings *settings;
    bool m_autoCheckNewVersion;
    int m_versionCode;
};
#endif // SETTINGS

