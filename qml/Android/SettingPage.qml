import QtQuick 2.4
import Material 0.1
import Material.ListItems 0.1 as ListItem
import "../JavaScript/main.js" as Script
import "Dialog"
Page{
    id:settingpage;
    title: qsTr("Settings");
    Rectangle{
        anchors.fill: parent;
        color: "white";
    }

    Column{
        anchors.fill: parent;
        anchors.topMargin: Units.dp(16);
        Label{
            style: "caption";
            color: Theme.primaryColor;
            text: qsTr("Support");
            anchors.left: parent.left;
            anchors.leftMargin: Units.dp(16);
        }
        ListItem.Subtitled{
            subText: qsTr("Click to check new version");
            text: qsTr("New version");
        }
        ThinDivider{
            width: parent.width-Units.dp(32);
        }
        ListItem.Standard{
            text: qsTr("About");
            onClicked: aboutdialog.open();
        }
    }
    AboutDialog{
        id: aboutdialog;
    }
    VersionCheckDialog{
        id:versionCheckDialog;
    }

    Keys.onBackPressed: {
        pageStack.pop();
    }
    Component.onCompleted: {
        Script.versionCheckDialog = versionCheckDialog;
    }
}
