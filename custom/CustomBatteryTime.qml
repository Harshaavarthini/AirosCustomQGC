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
import CustomBattery 1.0


Item {

    id:                     _root
    property var    battery1:           activeVehicle ? activeVehicle.battery  : null
    property var    battery2:           activeVehicle ? activeVehicle.battery2 : null
    property bool   hasSecondBattery:   battery2 && battery2.voltage.value !== -1
    property var    timeEstimate    :   "--/--"

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


/*   function estimate() {
        var current=battery1.current.value;
        var ibat=(3300-battery1.mahConsumed.value) *20 ;
        var k=60/2;
        if (current>0 && battery1.mahConsumed.value >100 ){
            var time= ibat / (current*1000*k)*60*60;
            var minsec=secondsToHHMMSS(time)
            return minsec;

        }
        return  "--/--"
    }*/


    function estimateBattery(){
        if(activeVehicle){
            CustomBattery.vehicle=activeVehicle
            CustomBattery.batt=activeVehicle.battery
            var time = CustomBattery.estimate;
            if (time === -1) {return "--/--";}
            var minsec=secondsToHHMMSS(time)
            return minsec
        }else {
            return "Na"
        }


    }



    function getBatteryPercentageText(battery) {
        if(battery) {
            if(battery.percentRemaining.value > 98.9) {
                return "100%";
            }
            if(battery.percentRemaining.value > 0.1) {
                return battery.percentRemaining.valueString + battery.percentRemaining.units;
            }
            if(battery.voltage.value >= 0) {
                return battery.voltage.valueString + battery.voltage.units;
            }
        }
        return "N/A"
    }

    function barGreen(){
        if(activeVehicle.battery.percentRemaining.value >=70){
            return true;
        }
        return false;
    }

    function barOrange(){
        if(activeVehicle.battery.percentRemaining.value <70 && activeVehicle.battery.percentRemaining.value >30 ){
            return true;
        }
        return false;
    }

    function barRed(){
        if(activeVehicle.battery.percentRemaining.value <=30  ){
            return true;
        }
        return false;
    }



    function barLen(){

         timeEstimate=estimateBattery()
        //estimate()
        return  activeVehicle.battery.percentRemaining.value * (mainWindow.width/100);
    }



    Row{
        id: batteryTimeRow
        Rectangle {
            id: green
            width: barLen()
            height: 5
            color: qgcPal.colorGreen
            border.color: "black"
            border.width: 0.5
            radius: 1
            visible: barGreen()
            }
        Rectangle {
            id: orange
            width: barLen()
            height: 5
            color: qgcPal.colorOrange
            border.color: "black"
            border.width: 0.5
            radius: 1
            visible: barOrange()
            }
        Rectangle {
            id: red
            width: barLen()
            height: 5
            color: qgcPal.colorRed
            border.color: "black"
            border.width: 0.5
            radius: 1
            visible: barRed()
            }

            Rectangle {
                color: qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(1,1,1,0.95) : Qt.rgba(0,0,0,0)
                width:                  time.width
                height:                 time.height
                radius: 5
                anchors.right: green.right
                anchors.rightMargin: 0
                anchors.top: green.bottom
                anchors.topMargin: 0
                QGCLabel {
                    id: time
                    text:timeEstimate
                    font.pointSize:         ScreenTools.mediumFontPointSize
                }

            }
            }


     }






