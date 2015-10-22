import QtQuick 2.4
QtObject{
    id:signalcenter;
    signal loadStarted;
    signal loadFinished;
    signal loadFailed(string errorstring);


    signal accessTokenGeted;


    function showMessage(msg){
        console.log(msg);
        if (msg||false){
            if(snackbar.opened){
                snackbar.open(snackbar.text + "\n" +msg);

            }
            else snackbar.open(msg);
        }
    }
}
