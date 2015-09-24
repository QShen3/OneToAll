import QtQuick 1.1
import com.nokia.symbian 1.1
import "../JavaScript/main.js" as Script
import "BaseComponent"
import "Dialog"
MyPage{
    id:settingpage;
    title: qsTr("Settings");
    Head{
        id:head;
        titleText: title;
        z:1;
    }
    tools: ToolBarLayout{
        ToolButton{
            iconSource: "toolbar-back";
            platformInverted: true;
            onClicked: pageStack.pop();
        }
    }
    Column{
        id: settingitem;
        anchors{
            top: head.bottom;
            topMargin: 20;
            left: parent.left;
            right: parent.right;
        }
        CheckBox {
            id:autoinstall;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            text: qsTr("Automatically check for new version when the software is opened");
            platformInverted: true;
            checked: settings.autoCheckNewVersion;
            onClicked: {
                settings.autoCheckNewVersion = checked;
            }
        }
    }
    Column{
        id: settingbutton;
        anchors{
            top: settingitem.bottom;
            topMargin: 20;
            left: parent.left;
            right: parent.right;
        }
        spacing: 20;
        Button{
            platformInverted: true;
            width: 300;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: qsTr("Click to check new version");
            onClicked: Script.checkNewVersion(false);
        }
        Button{
            platformInverted: true;
            width: 300;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: qsTr("About");
            onClicked: aboutdialog.open();
        }
    }
    AboutDialog{
        id: aboutdialog;
    }
    Keys.onBackPressed: {
        pageStack.pop();
    }
}
