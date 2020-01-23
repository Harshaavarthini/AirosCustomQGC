/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author
 */

import QtQuick                              2.11
import QtQuick.Controls                     1.4
import QtQuick.Layouts                      1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.CustomBattery 1.0


Item {

    id:                     _root
    property var    battery1:           activeVehicle ? activeVehicle.battery  : null
    property var    battery2:           activeVehicle ? activeVehicle.battery2 : null
    property bool   hasSecondBattery:   battery2 && battery2.voltage.value !== -1

    function secondsToHHMMSS(timeS) {
        var sec_num = parseInt(timeS, 10);
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);
        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        return minutes+':'+seconds;
    }

    CustomBattery {
       id: _custombattery
       batt: activeVehicle.battery
       cellNumber: activeVehicle.battery ? activeVehicle.battery.cellCount.value : 0

    }



    function getTimeBatteryEstimate (){
           if (custombattery.batt && _custombattery){
            return _custombattery.estimate
        }else
        {
            return "--/--"
        }
    }




    function barColor(){
        if (battery1){
            if(battery1.percentRemaining.value >=70){

                return qgcPal.colorGreen;
            }
            if(battery1.percentRemaining.value <70 && activeVehicle.battery.percentRemaining.value >30){

                return qgcPal.colorOrange;
            }
            if(battery1.percentRemaining.value <=30  ){

                return qgcPal.colorRed;
            }

        }
        return qgcPal.colorRed;

    }

   /*
    function barGreen(){
        if(activeVehicle.battery.percentRemaining.value >=70){
            timeEstimate=estimateBattery()
            return true;
        }
        return false;
    }

    function barOrange(){
        if(activeVehicle.battery.percentRemaining.value <70 && activeVehicle.battery.percentRemaining.value >30 ){
            timeEstimate=estimateBattery()
            return true;
        }
        return false;
    }

    function barRed(){
        if(activeVehicle.battery.percentRemaining.value <=30  ){
            timeEstimate=estimateBattery()
            return true;
        }
        return false;
    }
*/


    function barLen(){
        //timeEstimate=getTimeBatteryEstimate
        return battery1.percentRemaining.value * (mainWindow.width/100);

    }

    function getTimeEstimate(){
        if (battery1.percentRemaining.value >0.1 && _custombattery.batt ){
            if (_custombattery.estimate == -1){return "--/--"}
          return secondsToHHMMSS(_custombattery.estimate)
        }else {
            return "--/--"
        }

    }


        Rectangle {
            id: bar
            anchors.top:parent
            width: barLen()
            height: 5
            color: barColor()
            border.color: "black"
            border.width: 0.5
            radius: 1
            visible: true
            }

            Rectangle {
                color: qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(1,1,1,0.95) : Qt.rgba(0,0,0,0)
                width:                  time.width
                height:                 time.height
                radius: 5
                anchors.right: bar.right
                anchors.rightMargin: 0
                anchors.top: bar.bottom
                anchors.topMargin: 0
                QGCLabel {
                    id: time
                    text:getTimeEstimate()
                    font.pointSize:         ScreenTools.mediumFontPointSize
                }

            }
            }








