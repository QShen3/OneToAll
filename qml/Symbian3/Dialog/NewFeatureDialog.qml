import QtQuick 1.1
import com.nokia.symbian 1.1
CommonDialog{
    id:root;
    titleText: qsTr("New Features");
    platformInverted: true;
    buttonTexts: [qsTr("OK")];
    content: Flickable{
        anchors{
            left: parent.left;
            right: parent.right;
            top: parent.top;
            margins: 10;
        }
        height: 270;
        contentHeight: text.height
        Text{
            id: text;
            anchors{
                left: parent.left;
                right: parent.right;
                top: parent.top;
            }
            wrapMode: Text.WordWrap;
            text: qsTr("2015.11.15\nV 0.7.0\n\n1.Add support for Tencent Weibo\n2.Some optimization");
        }
    }
}

