import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "BaseComponent"
import "Delegate"
import "Dialog"
import "../JavaScript/main.js" as Script

MyPage {
    id: mainPage
    title: "OneToAll";
    property string uid;
    property string accessToken;

    property bool hasPic : false;
    Head{
        id:head;
        titleText: title;
        z:1;
    }
    tools: ToolBarLayout{
        ToolButton{
            iconSource: "toolbar-back";
            platformInverted: true;
            onClicked: {
                if(quitTimer.running){
                    saveUserData();
                    Qt.quit();
                }
                else{
                    infoBanner.text=qsTr("Please click again to quit");
                    infoBanner.open();
                    quitTimer.start();
                }
            }
        }
        ToolButton{
            iconSource: "toolbar-add";
            platformInverted: true;
            onClicked: choosedialog.open();
        }
        ToolButton{
            iconSource: "toolbar-settings";
            platformInverted: true;
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SettingPage.qml"));
            }
        }
    }
    Item{
        id:inputitem;
        anchors{
            top: head.bottom;
            left: parent.left;
            right: parent.right;
            margins: 15;
        }
        height: hasPic ?width * 0.5625 : width * 0.75;
        TextArea{
            id: inputtext;
            width: parent.width;
            anchors{
                top: parent.top;
                bottom: sendbutton.top;
                bottomMargin: 10;
            }
            platformInverted: true;
        }
        Row{
            anchors.left: parent.left;
            anchors.verticalCenter: sendbutton.verticalCenter;
            ToolButton{
                iconSource: "../pic/btn_insert_pics_inverted.png";
                platformInverted: true;
                onClicked: contextmenu.open();
            }
            ToolButton{
                iconSource: "../pic/btn_insert_face_inverted.png";
                platformInverted: true;
                onClicked: tempdialog.open();
            }
            ToolButton{
                iconSource: "../pic/btn_icon_edit_inverted.png";
                platformInverted: true;
                onClicked: inputtext.paste();
            }
        }
        ToolButton{
            id: sendbutton;
            anchors{
                right: parent.right;
                rightMargin: 10;
                bottom: parent.bottom;
            }
            platformInverted: true;
            text: qsTr("send");
            onClicked: {
                if(!hasPic){
                    inputtext.focus = false;
                    Script.sendText(inputtext.text);
                }
                else {
                    inputtext.focus = false;
                    Script.sendImage(inputtext.text , Script.cutStr(picture.source, 8) );
                }
            }
        }       
    }
    Image{
        id:picture;
        anchors{
            left: parent.left;
            top: inputitem.bottom;
            leftMargin: 15;
            topMargin: 10;
        }
        sourceSize.height: 80;
        height: hasPic ? sourceSize.height : 0;
        //width: sourceSize.width / sourceSize.height * height;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                contextmenu.open();
            }
        }
    }
    ListView{
        id:accountview;
        anchors{
            bottom: parent.bottom;
            left: parent.left;
            right: parent.right;
            top: picture.bottom;
            topMargin: 15;
        }
        clip: true;
        interactive: contentHeight > height;
        model: usermodel;
        delegate: UserComponent{}
        header: ListHeading{
            platformInverted: true;
            ListItemText{
                platformInverted: true;
                anchors.fill: parent.paddingItem;
                role: "Heading";
                text: qsTr("Account");
            }
        }
    }
    ScrollDecorator{
        flickableItem: accountview;
    }
    ChooseDialog{
        id:choosedialog;
    }
    CommonDialog{
        id:tempdialog;
        platformInverted: true;
        buttonTexts: [qsTr("OK")];
        content: Text{
            width: parent.width-20;
            anchors.horizontalCenter: parent.horizontalCenter;
            wrapMode: Text.WordWrap;
            text: qsTr("Write added this feature, so stay tuned");
        }
    }
    ContextMenu{
        id: contextmenu;
        platformInverted: true;
        MenuLayout{
            MenuItem{
                platformInverted: true;
                text: qsTr("Camera");
                onClicked: utility.captureImage();
            }
            MenuItem{
                platformInverted: true;
                text: qsTr("Photo library");
                onClicked: utility.selectImage();
            }
            MenuItem{
                platformInverted: true;
                text: qsTr("Delete");
                visible: hasPic;
                onClicked: hasPic = false;
            }
        }
    }
    ConfirmDialog{
        id: confirmdialog;
    }
    Timer{
        id: quitTimer;
        interval: 3000;
        running: false;
        repeat: false;
    }
    Connections{
        target: utility;
        onSelectImageFinished:{
            picture.source = "file:///" + imageUrl;
            hasPic = true;

        }
    }
    Connections{
        target: httprequest;
        onSendWeiboImageFinished:{
            Script.loadWeiboSendImageResult(oritxt);
        }
        onSendRenrenImageFinished:{
            Script.loadRenrenSendImageResult(oritxt);
        }

        onStatusChanged:{
            if(httprequest.status == 0) {
                app.loading = false;
                loadingind.close();
                processingtimer.stop();
            }
            else {
                app.loading = true;
                loadingind.open();
                processingtimer.restart();
            }
        }
    }
}
