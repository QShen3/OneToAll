import QtQuick 1.1
import com.nokia.symbian 1.1
CommonDialog{
    id:root;
    platformInverted: true;
    titleText: qsTr("Add an account");
    buttonTexts: [qsTr("Cancle")];
    content:Grid{
        anchors{
            left: parent.left;
            top: parent.top;
            margins: 10;
        }
        spacing: 15;
        Image{
            height: 60;
            width: 60;
            source: Qt.resolvedUrl("../../pic/Weibo_logo.svg");
            smooth: true;
            MouseArea {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Weibo"});
                    root.close();
                }
                anchors.fill: parent
            }
        }
        Image{
            height: 60;
            width: 60;
            source: Qt.resolvedUrl("../../pic/Renren_logo.svg");
            smooth: true;
            MouseArea {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Renren"});
                    root.close();
                }
                anchors.fill: parent
            }
        }
    }
}
