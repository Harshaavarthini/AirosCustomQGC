/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author Gus Grubba <gus@auterion.com>
 */

import QtQuick                              2.11
import QtQuick.Controls                     1.4
import QtQuick.Layouts                      1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.CustomBattery 1.0



//-------------------------------------------------------
//-- Battery Indicator
Item {
    id:                     _root
    width:                  batteryIndicatorRow.width
    anchors.top:            parent.top
    anchors.bottom:         parent.bottom

    property var    battery1:           activeVehicle ? activeVehicle.battery  : null
    property var    battery2:           activeVehicle ? activeVehicle.battery2 : null
    property bool   hasSecondBattery:   battery2 && battery2.voltage.value !== -1

    CustomBattery {
       id: _custombattery
       batt: activeVehicle.battery
       cellNumber: activeVehicle.battery ? activeVehicle.battery.cellCount.value : 0

    }
//-------------------------------------------------------------------
// Looking for the lowestBattery
    function lowestBattery() {
        if(activeVehicle) {
            if(hasSecondBattery) {
                if(activeVehicle.battery2.percentRemaining.value < activeVehicle.battery.percentRemaining.value) {
                    return activeVehicle.battery2
                }
            }
            return activeVehicle.battery
        }
        return null
    }

//-----------------------------------------------------------------------
/*    function getBatteryColor(battery) {
        if(battery1) {
            if(battery1.percentRemaining.value >= 70) {
                return qgcPal.colorGreen
            }
            if(battery1.percentRemaining.value < 70 && battery1.percentRemaining.value > 30) {
                return qgcPal.colorOrange
            }
            if(battery1.percentRemaining.value <=30) {
                return qgcPal.colorRed
            }
        }
        return qgcPal.colorRed
    }*/

//--------------------------------------------------------------------
    function getBatteryColor() {
        if(_custombattery.batt) {
            if(_custombattery.estimateLevel >= 70) {
                return qgcPal.colorGreen
            }
            if(_custombattery.estimateLevel < 70 && _custombattery.estimateLevel > 30) {
                return qgcPal.colorOrange
            }
            if(_custombattery.estimateLevel <=30) {
                return qgcPal.colorRed
            }
        }
        return qgcPal.colorRed
    }

//---------------------------------------------------------------------
    function getBatteryPercentageText(battery) {
        if(battery1) {
            if(battery1.percentRemaining.value > 98.9) {
                return "100%"
            }
            if(battery1.percentRemaining.value > 0.1) {
                return battery1.percentRemaining.valueString + battery.percentRemaining.units
            }
            if(battery.voltage.value >= 0) {
                return battery1.voltage.valueString + battery.voltage.units
            }
        }
        return "N/A"
    }

//---------------------------------------------------------------------
    function cellLevel(){
         if (battery1.percentRemaining.value >0.1 && _custombattery.batt){
             return _custombattery.estimateLevel + "%"

         }else {
            return "Na"
        }
    }
//---------------------------------------------------------------------
    function cellVoltage(){
         if (battery1.percentRemaining.value >0.1 && _custombattery.batt){
             return _custombattery.cellVoltage +battery1.voltage.units

         }else {
            return "Na"
        }
    }



    // Popup window show Battery info
    Component {
        id: batteryInfo

        Rectangle {
            width:  battCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: battCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window

            Column {
                id:                 battCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(battGrid.width, battLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             battLabel
                    text:           qsTr("Battery Status")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 battGrid
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel {
                        id:             batteryLabel
                        text:           qsTr("Battery 1")
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Repeater{
                        model: 1// getCellCount()
                        QGCColoredImage {
                            height:         batteryLabel.height
                            width:          height
                            sourceSize.width:   width
                            source:         "/qmlimages/Battery.svg"
                            color:         qgcPal.text
                            fillMode:       Image.PreserveAspectFit
                            /*Rectangle {
                                color:              getBatteryColor(activeVehicle ? activeVehicle.battery : null)
                                anchors.left:       parent.left
                                anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 0.125
                                height:             parent.height * 0.35
                                width:              activeVehicle ? (activeVehicle.battery.percentRemaining.value / 100) * parent.width * 0.875 : 0
                                anchors.verticalCenter: parent.verticalCenter
                            }*/
                    }



                    }

                    QGCLabel { text: qsTr("Voltage:") }
                    QGCLabel { text: (battery1 && battery1.voltage.value !== -1) ? (battery1.voltage.valueString + " " + battery1.voltage.units) : "N/A" }
                    QGCLabel { text: qsTr("Accumulated Consumption:") }
                    QGCLabel { text: (battery1 && battery1.mahConsumed.value !== -1) ? (battery1.mahConsumed.valueString + " " + battery1.mahConsumed.units) : "N/A" }
                    QGCLabel { text: qsTr("Current:") }
                    QGCLabel { text: (battery1 && battery1.current.value !== -1) ? (battery1.current.valueString + " " + battery1.current.units) : "N/A" }
                    QGCLabel { text: qsTr("CellNumber:") }
                    QGCLabel { text: (battery1 && _custombattery.batt) ?_custombattery.cellNumber: "---"  }
                    // Secondary battery
                    Item {
                        width:  1
                        height: 1
                        visible: hasSecondBattery;
                        Layout.columnSpan: 2
                    }

                    QGCLabel {
                        text:           qsTr("Battery 2")
                        visible:        hasSecondBattery
                        Layout.alignment: Qt.AlignVCenter
                    }
                    QGCColoredImage {
                        height:         batteryLabel.height
                        width:          height
                        sourceSize.width:   width
                        source:         "/qmlimages/Battery.svg"
                        color:          qgcPal.text
                        visible:        hasSecondBattery
                        fillMode:       Image.PreserveAspectFit
                        Rectangle {
                            color:              getBatteryColor(activeVehicle ? activeVehicle.battery2 : null)
                            anchors.left:       parent.left
                            anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 0.125
                            height:             parent.height * 0.35
                            width:              activeVehicle ? (activeVehicle.battery2.percentRemaining.value / 100) * parent.width * 0.875 : 0
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    QGCLabel { text: qsTr("Voltage:"); visible: hasSecondBattery; }
                    QGCLabel { text: (battery2 && battery2.voltage.value !== -1) ? (battery2.voltage.valueString + " " + battery2.voltage.units) : "N/A";  visible: hasSecondBattery; }
                    QGCLabel { text: qsTr("Accumulated Consumption:"); visible: hasSecondBattery; }
                    QGCLabel { text: (battery2 && battery2.mahConsumed.value !== -1) ? (battery2.mahConsumed.valueString + " " + battery2.mahConsumed.units) : "N/A"; visible: hasSecondBattery; }
                }
            }
        }
    }

    // Toolbar Icon
    Row {
        id:             batteryIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        opacity:        (activeVehicle && activeVehicle.battery.voltage.value >= 0) ? 1 : 0.5
        spacing:        ScreenTools.defaultFontPixelWidth
        QGCColoredImage {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            width:              height
            sourceSize.width:   width
            source:             "/qmlimages/Battery.svg"
            color:              getBatteryColor() //getBatteryColor(activeVehicle ? activeVehicle.battery : null)//qgcPal.text
            fillMode:           Image.PreserveAspectFit

        }
        QGCLabel {
            id:                     label
            text:                   getBatteryPercentageText(lowestBattery())
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  getBatteryColor()//getBatteryColor(lowestBattery())
            anchors.top:            parent.top
            visible: false
        }
        QGCLabel {
            text:                   cellLevel()
            font.pointSize:         ScreenTools.mediumFontPointSize*0.9
            color:                  getBatteryColor()//getBatteryColor(lowestBattery())
        }
        QGCLabel {
            text:                   cellVoltage()
            font.pointSize:         ScreenTools.mediumFontPointSize *0.9
            color:                  getBatteryColor()//getBatteryColor(lowestBattery())
        }


    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showPopUp(_root, batteryInfo)
        }
    }
}
