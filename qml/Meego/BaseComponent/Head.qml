// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
Rectangle{
    property alias titleText:headtext.text;
    property alias shadowOpacity:shadow.opacity;
    anchors.top: parent.top;
    width: parent.width;
    height: 72;
    color: "#1086D4";
    /*Image{
        anchors.fill: parent;
        source: "../../pic/Headerbar.svg";
    }*/

    Text{
        id:headtext;
        anchors{
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            leftMargin: 15;
        }
        font.pixelSize: 30;
    }
    Image{
        id:shadow;
        anchors.top: parent.bottom;
        width: parent.width;
        source: "../../pic/HeadShadow.png";
        opacity: 0.75;
    }
}
