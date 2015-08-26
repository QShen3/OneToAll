.pragma library
Qt.include("key.js")
var signalcenter;
var utility;
var httprequest;

function initialize(sc, ut, hr, um){
    signalcenter = sc;
    utility = ut;
    httprequest = hr;
    usermodel = um;
}

function cutStr(string,start,end){
    string=string.toString();
    if(end)
        return string.substring(start,end);
    else return string.substring(start);
}
function sendWebRequest(url, callback, method, postdata) {
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        switch(xmlhttp.readyState) {
        case xmlhttp.OPENED:signalcenter.loadStarted();break;
        case xmlhttp.HEADERS_RECEIVED:if (xmlhttp.status != 200)signalcenter.loadFailed(qsTr("connect erro,code:")+xmlhttp.status+"  "+xmlhttp.statusText);break;
        case xmlhttp.DONE:if (xmlhttp.status == 200) {
                try {
                    callback(xmlhttp.responseText);
                    signalcenter.loadFinished();
                } catch(e) {
                    signalcenter.loadFailed(qsTr("loading erro..."));
                }
            } else {
                signalcenter.loadFailed("");
            }
            break;
        }
    }
    if(method==="GET") {
        xmlhttp.open("GET",url);
        xmlhttp.send();
    }
    if(method==="POST") {
        xmlhttp.open("POST",url);
        xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xmlhttp.setRequestHeader("Content-Length", postdata.length);
        xmlhttp.send(postdata);
    }
}

var usermodel;

//授权相关
var accessToken;
var uid;
var userindex = 0;
function getAccessToken(from,code){
    switch(from){
    case "Weibo" :
        var url = "https://api.weibo.com/oauth2/access_token";
        var postData = "client_id=1661137619&client_secret=" + weiboSecret() + "&grant_type=authorization_code&code="+code+"&redirect_uri=https://api.weibo.com/oauth2/default.html"
        sendWebRequest(url,loadWeiboAccessToken,"POST",postData);
        break;
    case "Renren" :
        var url = "https://graph.renren.com/oauth/token";
        var postData = "grant_type=authorization_code&client_id=f80960de14314cd1abd3cb6a7967db92&client_secret=" + renrenSecret() + "&redirect_uri=http://graph.renren.com/oauth/login_success.html&code="+code+"&scope=read_user_photo+photo_upload";
        //console.log(postData);
        sendWebRequest(url,loadRenrenAccessToken,"POST", postData);
        break;
    }
}
function loadWeiboAccessToken(oritxt){
    var obj=JSON.parse(oritxt);
    accessToken=obj.access_token;
    uid=obj.uid;
    getUserInfo("Weibo", uid, accessToken);
}
function loadRenrenAccessToken(oritxt){
    var obj = JSON.parse(oritxt);
    accessToken = obj.access_token;
    uid = obj.user.id;
    usermodel.append({"from":"Renren", "uid":uid, "accesstoken":accessToken, "name":obj.user.name, "profileImage":obj.user.avatar[3].url, "authorize": true,"checked":true, "refreshtoken": obj.refresh_token} )
}

function checkAccessToken(){
    if(usermodel.count > userindex){
        switch(usermodel.get(userindex).from){
        case "Weibo":
            checkWeiboAccessToken(usermodel.get(userindex).accesstoken);
            break;
        case "Renren":
            refreshRenrenAccessToken(usermodel.get(userindex).refreshtoken);
            break;
        }
    }
    else userindex = 0;
}
function checkWeiboAccessToken(aT){
    var url = "https://api.weibo.com/oauth2/get_token_info";
    var postText = "access_token="+aT;
    sendWebRequest(url, loadWeiboCheckResult, "POST", postText);
}
function loadWeiboCheckResult(oritxt){
    var obj = JSON.parse(oritxt);
    if(obj.expire_in === 0){
        usermodel.set(userindex,{"authorize" : false});
    }
    userindex++;
    checkAccessToken();
}

function refreshRenrenAccessToken(rT){
    var url = "https://graph.renren.com/oauth/token?grant_type=refresh_token&refresh_token="+rT+"&client_id=f80960de14314cd1abd3cb6a7967db92&client_secret=" + renrenSecret();
    sendWebRequest(url, loadRenrenRefreshResult, "GET", "");
}
function loadRenrenRefreshResult(oritxt){
    var obj = JSON.parse(oritxt);
    usermodel.set(userindex, {"refreshtoken" : obj.refresh_token, "accesstoken" : obj.access_token});
    userindex++;
    checkAccessToken();
}

//获取用户信息
function getUserInfo(from, uid, accesstoken){
    switch(from){
    case "Weibo":
        var url = "https://api.weibo.com/2/users/show.json?access_token="+accesstoken+"&uid="+uid;
        sendWebRequest(url, loadWeiboUserInfo, "GET", "");
        break;
    }
}
function loadWeiboUserInfo(oritxt){
    var obj = JSON.parse(oritxt);
    //console.log(oritxt);
    usermodel.append( {"from":"Weibo", "uid":obj.idstr, "accesstoken":accessToken, "name":obj.name, "profileImage":obj.profile_image_url, "authorize": true,"checked":true} );
    //console.log(obj.name+"  ok++");
}


//发送文字信息
function sendText(text){
    if(usermodel.count > userindex){
        if(usermodel.get(userindex).checked){
            switch(usermodel.get(userindex).from){
            case "Weibo":
                sendWeiboText(usermodel.get(userindex).accesstoken, text);
                break;
            case "Renren":
                sendRenrenText(usermodel.get(userindex).accesstoken, text);
                break;
            }
        }
        else{
            userindex++;
            textNext(text);
        }
    }
    else userindex = 0;
}
function sendWeiboText(accesstoken,text){
    var url = "https://api.weibo.com/2/statuses/update.json";
    var postText="access_token="+accesstoken+"&status="+encodeURIComponent(text);
    sendWebRequest(url,loadWeiboSendResult,"POST",postText);
}
function loadWeiboSendResult(oritxt){
    var obj=JSON.parse(oritxt);
    try{
        signalcenter.showMessage(qsTr("Weibo ") +obj.user.name+ qsTr(" send successful"));
    }
    catch(e){
        signalcenter.showMessage(qsTr("Weibo ") + obj.error);
    }
    userindex++;
    sendText(obj.text);
}
function sendRenrenText(accesstoken,text){
    var url = "https://api.renren.com/v2/status/put";
    var postText = "access_token=" + accesstoken + "&content=" + encodeURIComponent(text);
    sendWebRequest(url, loadRenrenSendResult, "POST", postText);
}
function loadRenrenSendResult(oritxt){
    var obj = JSON.parse(oritxt);
    try{
        signalcenter.showMessage(qsTr("Renren ") + obj.response.ownerId +qsTr(" send successful"));
    }
    catch(e){
        signalcenter.showMessage(qsTr("Renren ") + obj.error.message);
    }
    userindex++;
    sendText(obj.response.content);
}
function textNext(text){
    sendText(text);
}

var imageDate;
function sendImage(text, image) {
    if(usermodel.count > userindex){
        imageDate = image;
        if(usermodel.get(userindex).checked){
            switch(usermodel.get(userindex).from){
            case "Weibo":
                httprequest.sendWeiboImage(usermodel.get(userindex).accesstoken, image, text);
                break;
            case "Renren":
                httprequest.sendRenrenImage(usermodel.get(userindex).accesstoken, image, text);
                break;
            }
        }
        else{
            userindex++;
            imageNext(text, image);
        }
    }
    else {
        userindex = 0;
        imageDate = "NULL";
    }
}
function loadWeiboSendImageResult(oritxt){
    var obj=JSON.parse(oritxt);
    //console.log(qstr("Weibo ") +obj.user.name+ qsTr(" send successful"));
    try{
        signalcenter.showMessage(qsTr("Weibo ") + obj.user.name+ qsTr(" send successful"));
    }
    catch(e){
        signalcenter.showMessage(qsTr("Weibo ") + obj.error);
    }
    userindex++;
    sendImage(obj.text, imageDate);
}
function loadRenrenSendImageResult(oritxt){
    console.log(oritxt);
    var obj = JSON.parse(oritxt);
    try{
        signalcenter.showMessage(qsTr("Renren ") + obj.response.ownerId +qsTr(" send successful"));
    }
    catch(e){
        signalcenter.showMessage(qsTr("Renren ") + obj.error.message);
    }
    userindex++;
    sendImage(obj.response.description, imageDate);
}

function imageNext(text, image){
    sendImage(text, image);
}

//版本检查
var versionCheckDialog;
function checkNewVersion(isBackground){
    var url = "http://onetoall.sinaapp.com/version.php";
    if(isBackground)
        sendWebRequest(url, loadCheckNewVersionResultBackground, "GET", "");
    else sendWebRequest(url, loadCheckNewVersionResult, "GET", "");
}
function loadCheckNewVersionResult(oritxt){
    var obj = JSON.parse(oritxt);
    if(obj.versioncode > 2){   //versioncode 2  0.2.0
        if(utility.platformType === 0){

            versionCheckDialog.openDialog(true, obj.x86url)
        }
        else versionCheckDialog.openDialog(true, obj.armurl)
    }
    else versionCheckDialog.openDialog(false, "");
}

function loadCheckNewVersionResultBackground(oritxt){
    var obj = JSON.parse(oritxt);
    if(obj.versioncode > 2){   //versioncode 2  0.2.0
        if(utility.platformType === 0){

            versionCheckDialog.openDialog(true, obj.x86url)
        }
        else versionCheckDialog.openDialog(true, obj.armurl)
    }
}
