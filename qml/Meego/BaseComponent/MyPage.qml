import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: root;

    property string title;
    property bool loading;

    orientationLock: PageOrientation.LockPortrait;

    Keys.onPressed: {
        if (event.key === Qt.Key_Backspace){
            pageStack.pop();
            event.accepted = true;
        }
    }
}
