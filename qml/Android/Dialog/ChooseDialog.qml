import QtQuick 2.4
import Material 0.1
Dialog{
    id:root;
    title: qsTr("Add an account");
    hasActions: false;
    Grid{
        spacing: Units.dp(16);
        Image{
            height: Units.dp(48);
            width: Units.dp(48);
            source: Qt.resolvedUrl("../../pic/Weibo_logo.svg");
            smooth: true;
            Ink {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Weibo"});
                    root.close();
                }
                anchors.fill: parent
                z: -1
            }
        }
        Image{
            height: Units.dp(48);
            width: Units.dp(48);
            source: Qt.resolvedUrl("../../pic/Renren_logo.svg");
            smooth: true;
            Ink {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Renren"});
                    root.close();
                }
                anchors.fill: parent
                z: -1
            }
        }
        Image{
            height: Units.dp(48);
            width: Units.dp(48);
            source: Qt.resolvedUrl("../../pic/TencrntWeibo_logo.svg");
            smooth: true;
            Ink {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"TencentWeibo"});
                    root.close();
                }
                anchors.fill: parent
                z: -1
            }
        }
    }
}
