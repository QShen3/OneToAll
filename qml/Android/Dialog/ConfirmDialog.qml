import QtQuick 2.4
import  Material 0.1
Dialog {
    id: confirmdia;
    property int deleteIndex;
    title: qsTr("Delete account");
    hasActions: true;
    text: qsTr("Are you sure you want to delete this account?");
    onAccepted: usermodel.remove(deleteIndex);
    function openDialog(index){
        deleteIndex = index;
        open();
    }
}

