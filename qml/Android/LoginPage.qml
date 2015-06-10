import QtQuick 2.4
import QtWebView 1.0
//import QtWebKit 3.0
import Material 0.1
import "../JavaScript/main.js" as Script
Page{
    id:loginpage;
    property string from;
    title: qsTr("Add account");

    WebView{
        id:webview;
        anchors.fill: parent;
        url:{
            switch(from){
            case "Weibo":
                return "https://open.weibo.cn/oauth2/authorize?client_id=1661137619&redirect_uri=https://api.weibo.com/oauth2/default.html&display=mobile&scope=follow_app_official_microblog";
            case "Renren":
                return "https://graph.renren.com/oauth/authorize?client_id=f80960de14314cd1abd3cb6a7967db92&response_type=code&redirect_uri=http://graph.renren.com/oauth/login_success.html&display=touth&scope=publish_feed status_update"
            }
        }
        onUrlChanged: {
            if(Script.cutStr(url,0,41) === "https://api.weibo.com/oauth2/default.html"){
                Script.getAccessToken("Weibo",Script.cutStr(url,47));
                pageStack.pop();
            }
            if(Script.cutStr(url,0,48) === "http://graph.renren.com/oauth/login_success.html"){
                //console.log(url);
                //console.log(Script.cutStr(url,54));
                Script.getAccessToken("Renren",Script.cutStr(url,54));
                pageStack.pop();
            }
        }
    }
}

