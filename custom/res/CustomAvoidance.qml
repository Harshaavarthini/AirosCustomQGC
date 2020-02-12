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
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.CustomBattery         1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0



Item {

    id: _CustomAvoidance


    Connections {
        target: QGroundControl.multiVehicleManager.activeVehicle
        onConnectionLostChanged: {

        }
        onActiveChanged: {
       }


    }


    Rectangle{
        id:                     avoid
        color:                  qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(1,1,1,0.95) : Qt.rgba(0,0,0,0.0)//0.3
        width:                  avoidGrid.width *2
        height:                 avoidGrid.height
        x:                      Math.round((mainWindow.width  - width)  * 0.5)//0.5
        y:                      Math.round((mainWindow.height - height) * 0.5)//0.5
        radius:                 2


        Grid {
            id:                    avoidGrid
            columnSpacing:         1
            rowSpacing:            1
            columns:               1
            anchors.centerIn:      parent
            Layout.fillWidth:     true



            Image {
                id:im1
                width:  ScreenTools.defaultFontPixelWidth *50
                height: ScreenTools.defaultFontPixelHeight
                source:     "/custom/img/LevelGreen.svg"
                cache:      false
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit

            }
            Image {
                id:im2
                width: ScreenTools.defaultFontPixelWidth *10
                height: ScreenTools.defaultFontPixelHeight
                source:     "/custom/img/LevelOrange.svg"
                cache:      false
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit

            }
            Image {
                id:im3
                width: ScreenTools.defaultFontPixelWidth *10
                height: ScreenTools.defaultFontPixelHeight
                source:     "/custom/img/LevelRed.svg"
                cache:      false
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit

            }

        }



    }




}














