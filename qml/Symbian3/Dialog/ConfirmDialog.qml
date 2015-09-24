import QtQuick 1.1
import com.nokia.symbian 1.1
QueryDialog {
    id: confirmdia;
    property int deleteIndex;
    platformInverted: true;
    titleText: qsTr("Delete account");
    message: qsTr("Are you sure you want to delete this account?");
    acceptButtonText: qsTr("OK");
    rejectButtonText: qsTr("Cancle");
    onAccepted: usermodel.remove(deleteIndex);
    function openDialog(index){
        deleteIndex = index;
        open();
    }
}

