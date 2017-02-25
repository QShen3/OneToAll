import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import QtQuick.Window 2.2

import Material 0.2
import "BaseComponent"
import "Dialog"
import "../JavaScript/main.js" as Script
ApplicationWindow {
    id:app;
    property bool isWideScreen: width > height;

    property bool loading;
    visible: true;

    height: 600;
    width: height / 3 * 4;

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["pink"]["500"]
        tabHighlightColor: "white"
    }
    SignalCenter{
        id:signalcenter;
    }
    LoadingIndicator{
        id:loadingind;
    }
    Snackbar{
        id:snackbar;
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
        if(settings.autoCheckNewVersion){
            Script.checkNewVersion(true);
        }
        if(settings.versionCode < 1){
            newfeaturedialog.open();
            settings.versionCode = 1;
        }
        pageStack.push(homepage);

        console.log("Win32 platform");

        //console.log(Units.dp(1))
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
