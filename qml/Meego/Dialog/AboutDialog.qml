import QtQuick 1.1
import com.nokia.meego 1.1
Dialog{
    id:root;
    title: qsTr("About");
    height: 430;
    content:Text{
        anchors{
            left: parent.left;
            right: parent.right;
            top: parent.top;
            margins: 10;
        }
        wrapMode: Text.WordWrap;
        font.pixelSize: 24;
        text: qsTr("This software is used to send status. It supports multiple social networking sites.\n\nCurrently in the testing phase,supporting Weibo and Renren.\n\nIt will support more social networking sites and function in future.\n\nMy e-mail: qazxdrcssc2006@163.com");
    }
}

