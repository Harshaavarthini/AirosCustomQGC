/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "CustomBattery.h"
#include <QQuickView>
#include <QtMath>
QGC_LOGGING_CATEGORY(CustomBatteryLog, "CustomBatteryLog")

static const char* kGroupName       = "CustomBatterySettings";
static const char* kCellNumber      = "cellNumber";
static const char* kshowFeautures      = "showFeautures";



//-----------------------------------------------------------------------------
CustomBattery::CustomBattery(QObject* parent)
    : QObject(parent)
{

    qCDebug(CustomBatteryLog) << "Creating CustomBattery instance";
    QSettings settings;
    settings.beginGroup(kGroupName);
    _CellNumber = settings.value(kCellNumber, 1).toInt();
    _showFeautures= settings.value(kshowFeautures,0).toBool();

}

//-----------------------------------------------------------------------------
CustomBattery::~CustomBattery()
{

}


//-----------------------------------------------------------------------------

void CustomBattery::setvehicle(Vehicle *set)
{
    if(_vehicle!=set){
        _vehicle=set;
        emit vehicleChanged();

    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setbatt(VehicleBatteryFactGroup* set)
{
    if(_batt!=set){
        _batt=set;
        emit battChanged();


    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setShowFeautures(bool set){
    if (_showFeautures!=set){
        _showFeautures=set;
        QSettings settings;
        settings.beginGroup(kGroupName);
        settings.setValue(kshowFeautures,set);
        emit showFeauturesChanged();
     }

}


//-----------------------------------------------------------------------------

void CustomBattery::setCellNumber(int set){

    if (_CellNumber!=set && set > 1){
        _CellNumber=set;
        QSettings settings;
        settings.beginGroup(kGroupName);
        settings.setValue(kCellNumber,set);
        emit CellNumberChanged();
    }
}

//-----------------------------------------------------------------------------

double CustomBattery::timeEstimate()
{

    double current,mahConsumed,ibat,k;
    double time=0;

    if ( _batt==nullptr) {
        return -1;
    }
    mahConsumed =_batt->mahConsumed()->rawValue().toDouble();
    current= _batt->current()->rawValue().toDouble();
    ibat=(5200-mahConsumed)*20;
    k=60/2;
    if (current>0 && mahConsumed>50){

        time=ibat/(current*1000*k)*60*60;
         emit timeEstimateChanged();
        return time;

    }else
    {
        emit timeEstimateChanged();
        return -1;
    }

}


//-----------------------------------------------------------------------------

double CustomBattery::cellVoltage(){

    double voltage=_batt->voltage()->rawValue().toDouble();
    if (voltage>LIPOMIM && _CellNumber>0){

         double var=voltage/_CellNumber;
         int value = (int)(var * 100 );
         emit cellVoltageChanged();
         return (double)value / 100;

    }else
    {
        emit cellVoltageChanged();
        return -1;
    }


}

//-----------------------------------------------------------------------------

int CustomBattery::levelEstimate(){

    _CellVoltage=cellVoltage();
        if (_CellVoltage>0){

            _estimateLevel=level(_CellVoltage*1000,3000,4200,&asigmoidal);
            emit estimateLevelChanged();

        }
        return  _estimateLevel;

}


//-----------------------------------------------------------------------------

uint8_t CustomBattery::level(uint16_t voltage,uint16_t minVoltage, uint16_t maxVoltage,mapFn_t mapFunction) {
    if (voltage <= minVoltage) {
        return 0;
    } else if (voltage >= maxVoltage) {
        return 100;
    } else {
        return (*mapFunction)(voltage, minVoltage, maxVoltage);
    }
}



