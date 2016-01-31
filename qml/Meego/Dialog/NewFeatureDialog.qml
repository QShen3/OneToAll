import QtQuick 1.1
import com.nokia.meego 1.1
Dialog{
    id:root;
    title: qsTr("New Features");
    content: Flickable{
        anchors{
            left: parent.left;
            right: parent.right;
            top: parent.top;
        }
        height: 360;
        contentHeight: text.height
        Text{
            id: text;
            anchors{
                left: parent.left;
                right: parent.right;
                top: parent.top;
            }
            color: "white";
            font.pixelSize: 24;
            wrapMode: Text.WordWrap;
            text: qsTr("2015.11.15\nV 0.7.0\n\n1.Add support for Tencent Weibo\n2.Some optimization");
        }
    }
}

