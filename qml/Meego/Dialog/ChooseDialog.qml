import QtQuick 1.1
import com.nokia.meego 1.1
Dialog{
    id:root;
    content:Grid{
        anchors{
            //verticalCenter: parent.verticalCenter;
            horizontalCenter: parent.horizontalCenter;
        }
        spacing: 20;
        Image{
            height: 80;
            width: 80;
            source: Qt.resolvedUrl("../../pic/Weibo_logo.svg");
            smooth: true;
            MouseArea {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Weibo"});
                    root.close();
                }
                anchors.fill: parent;
            }
        }
        Image{
            height: 80;
            width: 80;
            source: Qt.resolvedUrl("../../pic/Renren_logo.svg");
            smooth: true;
            MouseArea {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Renren"});
                    root.close();
                }
                anchors.fill: parent;
            }
        }
        Image{
            height: 80;
            width: 80;
            source: Qt.resolvedUrl("../../pic/TencrntWeibo_logo.svg");
            smooth: true;
            MouseArea {
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"TencentWeibo"});
                    root.close();
                }
                anchors.fill: parent;
            }
        }
    }
}
