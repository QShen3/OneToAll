import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import com.stars.widgets 1.0
/*ListDelegate{
    height: 80;
    width: screen.displayHeight;
    MouseArea{
        anchors.fill: parent;
        onPressAndHold: {
            confirmdialog.openDialog(index);
        }
    }

    MyImage{
        id: avatar;
        anchors{
            left: parent.left;
            leftMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        source: model.profileImage;
        sourceSize: Qt.size(60,60);
        smooth: true;
        maskSource: "../../pic/mask.bmp";
    }
    Column{
        anchors{
            left: avatar.right;
            leftMargin: 15;
            verticalCenter: parent.verticalCenter;
        }

        Text{
            text: model.name;
        }
        Text{
            text: model.from;
        }
    }
    Row{
        anchors{
            right: parent.right;
            rightMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        spacing: 5;
        Text{
            anchors.verticalCenter: parent.verticalCenter;
            //platformInverted: true;
            text: qsTr("Authorize expired!");
            color: "red";
            visible: !model.authorize;
        }
        CheckBox{
            //platformInverted: true;
            checked: model.checked;
            enabled: model.authorize;
            onCheckedChanged: {
                usermodel.set(index, {"checked": checked});
            }
        }
    }
    onClicked: {
        if(!model.authorize){
            switch(model.from){
            case "Weibo":
                pageStack.push(Qt.resolvedUrl("../LoginPage.qml"),{from:"Weibo"});
                usermodel.remove(index);
                break;
            }
        }
    }
}*/
/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/
Item {
    id: listItem

    signal clicked
    property alias pressed: mouseArea.pressed

    property int titleSize: 26
    property int titleWeight: Font.Bold
    property color titleColor: "#282828"

    property int subtitleSize: 22
    property int subtitleWeight: Font.Light
    property color subtitleColor: "#505050"
    height: 88
    width: parent.width

    BorderImage {
        id: background
        anchors.fill: parent
        // Fill page porders
        anchors.leftMargin: -16
        anchors.rightMargin: -16
        visible: mouseArea.pressed
        source: "image://theme/meegotouch-list-background-pressed-center"
    }

    Row {
        anchors.fill: parent;
        anchors.leftMargin: 16;
        spacing: 18

        MyImage {
            anchors.verticalCenter: parent.verticalCenter;
            visible: model.profileImage ? true : false
            width: 64
            height: 64
            source: model.profileImage ? model.profileImage : ""
            maskSource: "../../pic/mask.bmp";
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: mainText
                text: model.name
                font.weight: listItem.titleWeight
                font.pixelSize: listItem.titleSize
                color: listItem.titleColor
            }

            Label {
                id: subText
                text: model.from
                font.weight: listItem.subtitleWeight
                font.pixelSize: listItem.subtitleSize
                color: listItem.subtitleColor

                visible: text != ""
            }
        }
    }
    Row{
        anchors{
            right: parent.right;
            rightMargin: 15;
            verticalCenter: parent.verticalCenter;
        }
        spacing: 5;
        Text{
            anchors.verticalCenter: parent.verticalCenter;
            //platformInverted: true;
            text: qsTr("Authorize expired!");
            color: "red";
            visible: !model.authorize;
        }
        CheckBox{
            //platformInverted: true;
            checked: model.checked;
            enabled: model.authorize;
            onCheckedChanged: {
                usermodel.set(index, {"checked": checked});
            }
        }
    }
    MouseArea {
        id: mouseArea;
        anchors.fill: parent
        onClicked: {
            listItem.clicked();
        }
    }
}

