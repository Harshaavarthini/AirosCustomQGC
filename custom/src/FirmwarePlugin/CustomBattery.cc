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


//-----------------------------------------------------------------------------
CustomBattery::CustomBattery(QObject* parent)
    : QObject(parent)
{

    qCDebug(CustomBatteryLog) << "Creating CustomBattery instance";

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
        emit setvehicleChanged();

    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setbatt(VehicleBatteryFactGroup* set)
{
    if(_batt!=set){
        _batt=set;
        emit setbattChanged();


    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setCellNumber(int set){

    if (_CellNumber!=set && set > 1){
        _CellNumber=set;
        emit setCellNumberChanged();
    }else {
        _CellNumber=4;
    }
}

//-----------------------------------------------------------------------------

double CustomBattery::estimate()
{

    double current,mahConsumed,ibat,k;
    double time=0;

    if ( _batt==nullptr) {
        return -1;
    }
    mahConsumed =_batt->mahConsumed()->rawValue().toDouble();
    current= _batt->current()->rawValue().toDouble();
    ibat=(3300-mahConsumed)*20;
    k=60/2;
    if (current>0 && mahConsumed>50){

        time=ibat/(current*1000*k)*60*60;
         emit setestimateChanged();
        return time;

    }else
    {
        emit setestimateChanged();
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

int CustomBattery::estimateLevel(){

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



