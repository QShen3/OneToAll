import QtQuick 1.1
import com.nokia.symbian 1.1
import com.stars.widgets 1.0
ListItem{
    height: 80;
    width: screen.width;
    platformInverted: true;
    MyImage{
        id: avatar;
        anchors{
            left: parent.left;
            leftMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        source: model.profileImage;
        sourceSize: Qt.size(60,60);
        smooth: true;
        maskSource: "../../pic/mask.bmp";
    }
    Column{
        anchors{
            left: avatar.right;
            leftMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        ListItemText{
            text: model.name;
            platformInverted: true;
            role: "Title";
        }
        ListItemText{
            text: model.from;
            platformInverted: true;
            role: "Subtitle";
        }
    }
    Row{
        anchors{
            right: parent.right;
            rightMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        spacing: 5;
        ListItemText{
            anchors.verticalCenter: parent.verticalCenter;
            platformInverted: true;
            text: qsTr("Authorize expired!");
            color: "red";
            visible: !model.authorize;
        }
        CheckBox{
            platformInverted: true;
            checked: model.checked;
            enabled: model.authorize;
            onCheckedChanged: {
                usermodel.set(index, {"checked": checked});
            }
        }
    }
    onClicked: {
        if(!model.authorize){
            switch(model.from){
            case "Weibo":
                pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Weibo"});
                usermodel.remove(index);
                break;
            }
        }
    }
    onPressAndHold: {
        confirmdialog.openDialog(index);
    }
}
