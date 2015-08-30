import QtQuick 2.4
import Material 0.1
Dialog{
    id:root;
    title: qsTr("New Features");
    Label{
        width: parent.width;
        wrapMode: Text.WordWrap;
        text: qsTr("2015.8.30\nV 0.5.0\n\n1.Add sending picture feature\n2.Now you can press and hold the account to delete it\n3.Fix some bug");
    }
}

