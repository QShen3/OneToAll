import QtQuick 2.4
import material 0.1
Dialog {
    id: versioncheckdia;
    property bool hasNewVersion;
    property string url;
    title: qsTr("Check the new version");
    hasActions: true;
    text: hasNewVersion ? qsTr("Found a new version.Start download now?") : qsTr("The current version is the latest version");
    onAccepted: hasNewVersion ? Qt.openUrlExternally(url) : close();

    function openDialog(hnv , u){
        hasNewVersion = hnv;
        url = u;
        open();
    }
}

