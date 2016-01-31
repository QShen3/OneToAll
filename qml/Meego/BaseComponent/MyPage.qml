import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: root;

    property string title;
    property bool loading;

    //width: screen.displayWidth;
    //height: screen.displayHeight;
    //width: 480;
    //height: 854;

    orientationLock: PageOrientation.LockPortrait;

    Keys.onPressed: {
        if (event.key === Qt.Key_Backspace){
            pageStack.pop();
            event.accepted = true;
        }
    }
    //Component.onCompleted: console.log(root.height + " " + root.width);
}
