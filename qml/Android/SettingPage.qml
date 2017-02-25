import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "../JavaScript/main.js" as Script
import "Dialog"
Page{
    id:settingpage;
    title: qsTr("Settings");
    canGoBack: true;
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
            text: qsTr("Normal");
            anchors.left: parent.left;
            anchors.leftMargin: Units.dp(16);
        }
        ListItem.Subtitled{
            subText: qsTr("Automatically check for new version when the software is opened");
            text: qsTr("Automatically check for new version");
            secondaryItem: CheckBox{
                checked: settings.autoCheckNewVersion;
                onCheckedChanged: {
                    settings.autoCheckNewVersion = checked;
                }
            }
        }

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
            onClicked: Script.checkNewVersion(false);
        }
        ThinDivider{
            anchors.leftMargin: Units.dp(16);
            anchors.rightMargin: Units.dp(16);
        }
        ListItem.Standard{
            text: qsTr("About");
            onClicked: aboutdialog.open();
        }
    }
    AboutDialog{
        id: aboutdialog;
    }
}
