import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import Material 0.1
import "BaseComponent"
import "../JavaScript/main.js" as Script
ApplicationWindow {
    id:app;
    property bool loading;
    visible: true;
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
        onTriggered: signalCenter.loadFailed("erro");
    }
    HomePage{
        id:homepage;
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
        Script.setsignalcenter(signalcenter);
        Script.usermodel = usermodel;
        loadUserData(userdata.getUserData("UserData"));
        Script.checkAccessToken();
        pageStack.push(homepage);
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
