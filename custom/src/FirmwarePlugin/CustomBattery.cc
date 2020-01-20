#include "CustomBattery.h"
#include <QQuickView>
//-----------------------------------------------------------------------------
CustomBattery::CustomBattery(QObject* parent)
    : QObject(parent)
{

}

//-----------------------------------------------------------------------------
CustomBattery::~CustomBattery()
{

}

void CustomBattery::setidControl(int set)
{
    if(_idControl!=set){
        _idControl=set;
        emit setidControltChanged();

    }

}

void CustomBattery::setvehicle(Vehicle *set)
{
    if(_vehicle!=set){
        _vehicle=set;
        emit setvehicleChanged();

    }
}


void CustomBattery::setbatt(VehicleBatteryFactGroup* set)
{
    if(_batt!=set){
        _batt=set;
        emit setbattChanged();
        _estimate=60;

    }
}

double CustomBattery::estimate()
{
    double current,mahConsumed,ibat,k;
    double time;

   // voltage =_batt->voltage()->rawValue().toDouble();
    mahConsumed =_batt->mahConsumed()->rawValue().toDouble();
    current= _batt->current()->rawValue().toDouble();

    ibat=(3300-mahConsumed)*20;
    k=60/2;
    if (current>0 && mahConsumed>50){

        time=ibat/(current*1000*k)*60*60;
        return time;

    }else
    {
        return -1;
    }

}



