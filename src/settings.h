#ifndef SETTINGS
#define SETTINGS
#include <QObject>

class QSettings;

class Settings : public QObject
     {
      Q_OBJECT
      Q_PROPERTY(bool autoCheckNewVersion READ isAutoCheckNewVersion WRITE setAutoCheckNewVersion NOTIFY AutoCheckNewVersionChanged)
      public:
            explicit Settings(QObject *parent = 0);
            ~Settings();
            Q_INVOKABLE bool isAutoCheckNewVersion();
            Q_INVOKABLE void setAutoCheckNewVersion(bool);
      signals:
             void AutoCheckNewVersionChanged();
      public slots:
                  void loadSettings();
                  void saveSettings();
                  void clear();
      private:
             QSettings *settings;
             bool m_autoCheckNewVersion;
     };
#endif // SETTINGS

