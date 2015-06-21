import QtQuick 2.4
import Material 0.1
import "Delegate"
import "Dialog"
import "../JavaScript/main.js" as Script

Page {
    id: homepage;
    title: "OneToAll";
    property string uid;
    property string accessToken;
    /*Action{
        id: backaction;
        iconName: "navigation/arrow_back";
        onTriggered: {
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
    backAction: backaction;*/
    actions: [
        Action{
            iconName: "action/info";
            //name: "Info";
            onTriggered: aboutdialog.open();
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
                bottom: counter.top;
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
                onClicked: tempdialog.open();
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
            textColor: Theme.accentColor;
            text: qsTr("Send");
            onClicked: {
                inputtext.focus = false;
                Script.sendText(inputtext.text);
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
    AboutDialog{
        id: aboutdialog;
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




