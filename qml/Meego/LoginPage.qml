import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.meego 1.1
import "../JavaScript/main.js" as Script
import "BaseComponent"
MyPage{
    id:loginpage;
    property string from;
    title: qsTr("Add account");
    Head{
        id:head;
        titleText: title;
        z:1;
    }
    tools: ToolBarLayout{
        ToolIcon{
            iconId: "toolbar-back";
            platformStyle: ToolItemStyle{
                inverted: true;
            }
            onClicked: pageStack.pop();
        }
    }    
    WebView{
        id:webview;
        anchors.fill: parent;
        anchors.topMargin: head.height;
        preferredHeight: parent.height;
        preferredWidth: parent.width;
        url:{
            switch(from){
            case "Weibo":
                return "https://open.weibo.cn/oauth2/authorize?client_id=1661137619&redirect_uri=https://api.weibo.com/oauth2/default.html&display=mobile&scope=follow_app_official_microblog";
            case "Renren":
                return "https://graph.renren.com/oauth/authorize?client_id=f80960de14314cd1abd3cb6a7967db92&response_type=code&redirect_uri=http://graph.renren.com/oauth/login_success.html&display=touth&scope=publish_feed status_update"
            case "TencentWeibo":
                return "https://graph.qq.com/oauth2.0/authorize?client_id=101258308&response_type=code&redirect_uri=http://onetoall.sinaapp.com/successful.php&scope=get_info,add_t,add_pic_t";
            }
        }
        onUrlChanged: {
            if(Script.cutStr(url,0,41) === "https://api.weibo.com/oauth2/default.html"){
                Script.getAccessToken("Weibo",Script.cutStr(url,47));
                pageStack.pop();
            }
            else if(Script.cutStr(url,0,48) === "http://graph.renren.com/oauth/login_success.html"){
                Script.getAccessToken("Renren",Script.cutStr(url,54));
                pageStack.pop();
            }
            else if(Script.cutStr(url,0,42) === "http://onetoall.sinaapp.com/successful.php"){
                Script.getAccessToken("TencentWeibo",Script.cutStr(url,43));
                pageStack.pop();
            }
        }
    }    
}

