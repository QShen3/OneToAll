import QtQuick 1.1
import com.nokia.symbian 1.1
CommonDialog{
    id:root;
    titleText: qsTr("New Features");
    platformInverted: true;
    buttonTexts: [qsTr("OK")];
    content: Label{
        width: parent.width;
        wrapMode: Text.WordWrap;
        text: qsTr("2015.8.30\nV 0.5.0\n\n1.Add sending picture feature\n2.Now you can press and hold the account to delete it\n3.Fix some bug");
    }
}

