import QtQuick 2.4
import QtQuick.Dialogs 1.2
import Material 0.1
import "Delegate"
import "Dialog"
import "../JavaScript/main.js" as Script

Page {
    id: homepage;
    title: "OneToAll";
    property string uid;
    property string accessToken;

    property bool hasPic : false;
    actions: [
        Action{
            iconName: "action/settings";
            onTriggered: pageStack.push(Qt.resolvedUrl("SettingPage.qml"));
        }
    ]

    Card{
        id: inputcard;
        anchors{
            left: parent.left;
            right: parent.right;
            top: parent.top;
            margins: Units.dp(8);
        }
        height: width*0.75;
        Flickable{
            id:textflickable;
            anchors{
                left: parent.left;
                right: parent.right;
                top: parent.top;
                bottom: picture.top;
                margins: Units.dp(20);
            }
            contentHeight: inputtext.height;
            flickableDirection: Flickable.VerticalFlick;
            interactive: (contentHeight - Units.dp(8)) > height;
            clip: true;
            TextEdit{
                id: inputtext;
                height: contentHeight > textflickable.height ? contentHeight : textflickable.height;
                width: parent.width;
                wrapMode: Text.WordWrap;
                font.pixelSize: Units.dp(16);
                //selectByMouse: true;
            }
            onContentHeightChanged: contentHeight > height ? contentY = contentHeight - height : "";
        }
        Scrollbar{
            flickableItem: textflickable;
        }
        Image{
            id:picture;
            anchors{
                left: parent.left;
                bottom: counter.top;
                margins: Units.dp(20);
            }
            height: hasPic ? Units.dp(96) : 0;
            width: sourceSize.width / sourceSize.height * height;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    actionSheet.open();
                }
            }
        }
        Label{
            id:counter;
            anchors{
                bottom: divider.top;
                right: parent.right;
                margins: Units.dp(16);
            }
            style: "caption";
            text: inputtext.length.toString()+"/140";
            color: inputtext.length > 140? Palette.colors["red"]["500"] : Qt.rgba(0,0,0,0.26);
        }
        ThinDivider{
            id:divider;
            width: parent.width;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: sendbutton.height+Units.dp(16);
        }
        Row{
            anchors{
                left: parent.left;
                leftMargin: Units.dp(16);
                verticalCenter: sendbutton.verticalCenter;
            }
            spacing: Units.dp(16);
            IconButton{
                iconName: "editor/insert_photo";
                onClicked: actionSheet.open();
            }
            IconButton{
                iconName: "editor/insert_emoticon";
                onClicked: tempdialog.open();
            }
            IconButton{
                iconName: "action/assignment";
                onClicked: inputtext.paste();
            }
        }
        Button{
            id:sendbutton;
            anchors{
                right: parent.right;
                bottom: parent.bottom;
                margins: Units.dp(8);
            }
            textColor: Theme.primaryColor;
            text: qsTr("Send");
            onClicked: {
                if(!hasPic){
                    inputtext.focus = false;
                    Script.sendText(inputtext.text);
                }
                else {
                    inputtext.focus = false;
                    Script.sendImage(inputtext.text , Script.cutStr(picture.source, 7) );
                }
            }
        }
    }

    Card{
        id:accountcard
        anchors{
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            top: inputcard.bottom;
            topMargin: Units.dp(64);
        }
        ListView{
            id:accountview;
            anchors{
                fill: parent;
                topMargin: addbuttom.height / 2 + Units.dp(8);
                bottomMargin: Units.dp(8);
            }
            clip: true;
            interactive: (contentHeight - Units.dp(8)) > height;
            model: usermodel;
            delegate: UserComponent{}
        }
        Scrollbar{
            flickableItem: accountview;
        }
    }
    ActionButton{
        id:addbuttom;
        anchors{
            verticalCenter: accountcard.top;
            right: accountcard.right;
            rightMargin: Units.dp(32);
        }
        iconName: "content/add";
        onClicked: choosedialog.open();
    }
    Timer{
        id: quitTimer;
        interval: 3000;
        running: false;
        repeat: false;
    }
    ChooseDialog{
        id:choosedialog;
    }
    Dialog{
        id:tempdialog;
        hasActions: false;
        Label{
            text: qsTr("Write added this feature, so stay tuned");
        }
    }
    BottomActionSheet{
        id:actionSheet;
        title: qsTr("Image");
        actions: [
            Action{
                iconName: "image/photo_camera";
                name: qsTr("Camera");
                onTriggered: {
                    utility.captureImage();
                }
            },
            Action{
                iconName: "image/photo_library";
                name: qsTr("Photo library");
                onTriggered: utility.selectImage();
            },
            Action{
                iconName: "action/delete";
                name: qsTr("Delete");
                visible: hasPic;
                onTriggered: {
                    hasPic = false;
                    actionSheet.close();
                }
            }

        ]
    }
    ConfirmDialog{
        id: confirmdialog;
    }

    Connections{
        target: utility;
        onSelectImageFinished:{
            picture.source = "file://"+imageUrl;
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

    Keys.onBackPressed: {
        if(quitTimer.running){
            saveUserData();
            Qt.quit();
        }
        else {
            snackbar.open(qsTr("Please click again to quit"));
            quitTimer.start();
        }
    }
}




