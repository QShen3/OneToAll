import QtQuick 2.4
import Material 0.1
Dialog{
    id:root;
    title: qsTr("New Features");
    Label{
        width: parent.width;
        wrapMode: Text.WordWrap;
        text: qsTr("2016.3.10\nV 0.7.2\n\n1.Add support for Android Pad");
    }
}

