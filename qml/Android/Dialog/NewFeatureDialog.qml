import QtQuick 2.4
import Material 0.1
Dialog{
    id:root;
    title: qsTr("New Features");
    Label{
        width: parent.width;
        wrapMode: Text.WordWrap;
        text: qsTr("2015.11.14\nV 0.7.1\n\n1.Fix the bug that the new feature dialog displays wrong version message");
    }
}

