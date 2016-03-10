import QtQuick 2.4
import Material 0.2
Item{
    id:loadingind;
    state: "close";
    anchors.centerIn: parent;
    ProgressCircle{
        anchors.centerIn: parent;
    }
    function open(){
        loadingind.state="open";
    }
    function close(){
        loadingind.state="close";
    }
    states:[
        State{
            name:"close";
            PropertyChanges{
                target: loadingind;
                scale:0.5;
                opacity:0;
            }
        },
        State{
            name:"open";
            PropertyChanges{
                target: loadingind;
                scale:1;
                opacity:1;
            }
        }
    ]
    transitions:[
        Transition{
            from: "close";
            to:"open";
            PropertyAnimation{
                target: loadingind;
                properties: "scale,opacity";
                duration: 200;
            }
            reversible: true;
        }
    ]
}
