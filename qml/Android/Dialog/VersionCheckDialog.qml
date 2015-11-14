import QtQuick 2.4
import  Material 0.1
Dialog {
    id: versioncheckdia;
    property bool hasNewVersion;
    property string url;
    property string changeLog;
    title: qsTr("Check the new version");
    hasActions: true;
    text: hasNewVersion ? qsTr("Found a new version.Start downloading now?\n\nChangelog\n") + changeLog : qsTr("The current version is the latest version");
    onAccepted: hasNewVersion ? Qt.openUrlExternally(url) : close();

    function openDialog(hnv , u, c){
        hasNewVersion = hnv;
        url = u;
        changeLog = c;
        open();
    }
}

