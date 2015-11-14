import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../JavaScript/main.js" as Script
import "BaseComponent"
import "Dialog"

PageStackWindow {
    id: app;
    property bool loading;
    platformInverted: true;

    SignalCenter{
        id:signalcenter;
    }
    LoadingIndicator{
        id:loadingind;
    }
    InfoBanner{
        id: infoBanner;
    }
    StatusPaneText {
        id: statusPaneText;
    }
    Corners{
        id:corners;
    }

    Timer{
        id:processingtimer;
        interval: 60000;
        onTriggered: {
            signalcenter.loadFailed("erro");
            app.loading = false;
        }
    }

    HomePage{
        id:homepage;
    }

    VersionCheckDialog{
        id:versionCheckDialog;
    }
    NewFeatureDialog{
        id:newfeaturedialog;
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
        Script.versionCheckDialog = versionCheckDialog;       
        pageStack.push(homepage);
        if(settings.autoCheckNewVersion){
            Script.checkNewVersion(true);
        }
        if(settings.firstStart){
            newfeaturedialog.open();
            settings.firstStart = false;
        }
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
