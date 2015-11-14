import QtQuick 1.1
import com.nokia.symbian 1.1
QueryDialog {
    id: versioncheckdia;
    platformInverted: true;
    property bool hasNewVersion;
    property string url;
    titleText: qsTr("Check the new version");
    acceptButtonText: qsTr("OK");
    rejectButtonText: qsTr("Cancle");
    message: hasNewVersion ? qsTr("Found a new version.Start downloading now?") : qsTr("The current version is the latest version");
    onAccepted: hasNewVersion ? Qt.openUrlExternally(url) : close();

    function openDialog(hnv , u){
        hasNewVersion = hnv;
        url = u;
        open();
    }
}

