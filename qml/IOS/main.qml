import QtQuick 2.4
import QtQuick.Controls 1.3

import com.qshen.ios 0.1
import "BaseComponent"

import "../JavaScript/main.js" as Script
ApplicationWindow {
    id:app;
    property bool loading;
    visible: true;
    Rectangle{
        anchors.centerIn: parent;
        width: 100;
        height: 100;
        color: "red";
    }

    SignalCenter{
        id:signalcenter;
    }

    Timer{
        id:processingtimer;
        interval: 60000;
        onTriggered: {
            signalcenter.loadFailed("erro");
            app.loading = false;
        }
    }
    /*HomePage{
        id:homepage;
    }

    VersionCheckDialog{
        id:versionCheckDialog;
    }
    NewFeatureDialog{
        id:newfeaturedialog;
    }*/
    UIButton{

    }

    ListModel{
        id:usermodel;
    }
    Connections{
        target: signalcenter;
        onLoadStarted:{
            app.loading=true;
            loadingind.open();
            processingtimer.restart();
        }
        onLoadFinished:{
            app.loading=false;
            loadingind.close();
            processingtimer.stop();
        }
        onLoadFailed:{
            app.loading=false;
            loadingind.close();
            processingtimer.stop();
            signalcenter.showMessage(errorstring);
        }
    }

    Component.onCompleted:{
        Script.initialize(signalcenter, utility, httprequest, usermodel);
        loadUserData(userdata.getUserData("UserData"));
        Script.checkAccessToken();
        //Script.versionCheckDialog = versionCheckDialog;
        if(settings.autoCheckNewVersion){
            //Script.checkNewVersion(true);
        }
        if(settings.firstStart){
            //newfeaturedialog.open();
            settings.firstStart = false;
        }
        //pageStack.push(homepage);

        console.log("hereqml")
    }
    function saveUserData() {
        var arry=[];
        for(var i=0;i<usermodel.count;i++) {
            arry.push(usermodel.get(i));
        }
        var obj={"statuses": arry}
        userdata.setUserData("UserData",JSON.stringify(obj));
    }
    function loadUserData(oritxt) {
        if(!oritxt)
            oritxt="{\"statuses\":[]}";
        var obj=JSON.parse(oritxt);
        usermodel.clear();
        for(var i in obj.statuses) {
            usermodel.append(obj.statuses[i]);
        }
    }
}
