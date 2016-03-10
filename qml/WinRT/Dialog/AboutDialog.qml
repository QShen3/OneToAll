import QtQuick 2.4
import Material 0.2
Dialog{
    id:root;
    title: qsTr("About");
    Label{
        width: parent.width;
        wrapMode: Text.WordWrap;
        text: qsTr("This software is used to send status. It supports multiple social networking sites.\n\nCurrently in the testing phase,supporting Weibo and Renren.\n\nIt will support more social networking sites and function in future.\n\nMy e-mail: qazxdrcssc2006@163.com");
    }
}

