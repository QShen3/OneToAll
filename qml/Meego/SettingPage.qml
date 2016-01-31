import QtQuick 1.1
import com.nokia.meego 1.1
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
        ToolIcon{
            iconId: "toolbar-back";
            platformStyle: ToolItemStyle{
                inverted: true;
            }
            onClicked: pageStack.pop();
        }
    }
    Column{
        id: settingitem;
        anchors{
            top: head.bottom;
            topMargin: 27;
            left: parent.left;
            right: parent.right;
        }
        CheckBox {
            id:autoinstall;
            anchors.left: parent.left;
            anchors.leftMargin: 13;
            text: qsTr("Automatically check for new version when the software is opened");
            platformStyle: CheckBoxStyle{
                inverted: true;
            }
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
            topMargin: 27;
            left: parent.left;
            right: parent.right;
        }
        spacing: 27;
        Button{
            width: 400;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: qsTr("Click to check new version");
            onClicked: Script.checkNewVersion(false);
        }
        Button{
            //platformInverted: true;
            width: 400;
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
