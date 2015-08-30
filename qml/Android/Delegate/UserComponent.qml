import QtQuick 2.4
import QtGraphicalEffects 1.0
import Material 0.1
import Material.ListItems 0.1
BaseListItem{
    height: Units.dp(72);
    width: parent.width;
    Image{
        id:originalavatar;
        source: model.profileImage;
        sourceSize: Qt.size(Units.dp(40),Units.dp(40));
        smooth: true;
        visible: false;
    }
    Image{
        id:mask;
        source: "../../pic/Circle.svg";
        sourceSize: Qt.size(Units.dp(40),Units.dp(40));
        smooth: true;
        visible: false;
    }
    OpacityMask{
        id:avatar;
        anchors{
            left: parent.left;
            leftMargin: Units.dp(16);
            verticalCenter: parent.verticalCenter;
        }
        width: Units.dp(40);
        height: Units.dp(40);
        source: originalavatar;
        maskSource: mask;
    }
    Column{
        anchors{
            left: avatar.right;
            leftMargin: Units.dp(16);
            verticalCenter: parent.verticalCenter;
        }
        Label{
            text: model.name;
            style: "body1";
        }
        Label{
            text: model.from;
            style: "caption";
        }
    }
    Row{
        anchors{
            right: parent.right;
            rightMargin: Units.dp(16);
            verticalCenter: parent.verticalCenter;
        }
        spacing: Units.dp(8);
        Label{
            anchors.verticalCenter: parent.verticalCenter;
            text: qsTr("Authorize expired!");
            style: "caption";
            color: Palette.colors["red"]["500"];
            visible: !model.authorize;
        }
        CheckBox{
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
