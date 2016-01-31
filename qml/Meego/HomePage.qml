import QtQuick 1.1
import com.nokia.meego 1.1
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
    Rectangle{
        id: background;
        anchors.fill: parent;
        anchors.bottomMargin: accountview.height;
        color: "whitesmoke";
    }

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

            onClicked: {
                if(quitTimer.running){
                    saveUserData();
                    Qt.quit();
                }
                else{
                    infoBanner.text=qsTr("Please click again to quit");
                    infoBanner.show();
                    quitTimer.start();
                }
            }
        }
        ToolIcon{
            iconId: "toolbar-add";
            platformStyle: ToolItemStyle{
                inverted: true;
            }
            onClicked: choosedialog.open();
        }

        ToolIcon{
            iconId: "toolbar-settings";
            platformStyle: ToolItemStyle{
                inverted: true;
            }
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
            platformStyle: TextAreaStyle{
            }
        }
        Row{
            anchors.left: parent.left;
            anchors.verticalCenter: sendbutton.verticalCenter;
            ToolIcon{

                iconSource: "../pic/btn_insert_pics_inverted.png";
                platformStyle: ToolItemStyle{
                    inverted: false;
                }
                onClicked: contextmenu.open();
            }
            ToolIcon{
                iconSource: "../pic/btn_insert_face_inverted.png";
                platformStyle: ToolItemStyle{
                    inverted: false;
                }
                onClicked: tempdialog.open();
            }
            ToolIcon{
                iconSource: "../pic/btn_icon_edit_inverted.png";
                platformStyle: ToolItemStyle{
                    inverted: false;
                }
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
            platformStyle: ButtonStyle{
                inverted: false;
                buttonWidth: 100;
            }
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
            leftMargin: 20;
            topMargin: 10;
        }
        sourceSize.height: 107;
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
            bottom: mainPage.bottom;
            left: parent.left;
            right: parent.right;
            top: picture.bottom;
            topMargin: 20;
        }
        clip: true;
        //contentHeight: 80 + 88 * usermodel.count;
        //interactive: contentHeight > height;
        model: usermodel;
        delegate: UserComponent{}
        header: Item{
            height: 80;
            width: screen.displayHeight;
            Text{
                anchors{
                    left: parent.left;
                    leftMargin: 20;
                    verticalCenter: parent.verticalCenter;
                }
                text: qsTr("Account");
                font.pixelSize: 38;
            }
        }
        Image{
            anchors{
                top:parent.top;
                left: parent.left;
                right: parent.right;
            }
            source: "../pic/HeadShadow.png";
        }
        onContentHeightChanged: {
            console.log(contentHeight + " " + usermodel.count);
        }
    }
    ScrollDecorator{
        flickableItem: accountview;
    }
    ChooseDialog{
        id:choosedialog;
    }
    Dialog{
        id:tempdialog;
        height: 450;
        platformStyle: DialogStyle{
            inverted: false;
        }
        content: Text{
            color: "white";
            width: parent.width - 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            wrapMode: Text.WordWrap;
            font.pixelSize: 24;
            text: qsTr("Write added this feature, so stay tuned");
        }
    }
    ContextMenu{
        id: contextmenu;
        platformStyle: ContextMenuStyle{

        }

        MenuLayout{
            MenuItem{
                text: qsTr("Camera");
                onClicked: utility.captureImage();
            }
            MenuItem{
                text: qsTr("Photo library");
                //onClicked: utility.selectImage();
                onClicked: gallerysheet.open();
            }
            MenuItem{
                text: qsTr("Delete");
                visible: hasPic;
                onClicked: hasPic = false;
            }
        }
    }
    GallerySheet{
        id: gallerysheet;
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
        onSendTencentWeiboImageFinished:{
            Script.loadTencentWeiboSendImageResult(oritxt);
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
