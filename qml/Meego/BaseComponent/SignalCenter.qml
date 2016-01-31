import QtQuick 1.1
QtObject{
    id:signalcenter;
    signal loadStarted;
    signal loadFinished;
    signal loadFailed(string errorstring);

    signal accessTokenGeted;

    function showMessage(msg){
        //console.log(msg);
        if (msg||false){
            if(infoBanner.opened){
                infoBanner.text = infoBanner.text + "\n" +msg
                infoBanner.show();
            }
            else {
                infoBanner.text = msg;
                infoBanner.show();
            }
        }
    }
}
