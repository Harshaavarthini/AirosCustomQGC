#pragma once

#include "Vehicle.h"

#include <QObject>
#include <QTimer>
#include <QColor>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>


class CustomBattery:public QObject
{
     Q_OBJECT
public:
    CustomBattery(QObject* parent = nullptr);
    ~CustomBattery();
    Q_PROPERTY(bool     idControl   READ idControl  WRITE setidControl  NOTIFY setidControltChanged)
    Q_PROPERTY(Vehicle*     vehicle   READ vehicle  WRITE setvehicle  NOTIFY setvehicleChanged)
    Q_PROPERTY(VehicleBatteryFactGroup*     batt   READ batt  WRITE setbatt  NOTIFY setbattChanged)
    Q_PROPERTY(int    estimate   READ estimate )


    int    idControl           () { return _idControl; }
    Vehicle* vehicle () { return _vehicle; }
    VehicleBatteryFactGroup* batt () { return _batt; }
    double estimate();

    void    setidControl        (int set);
    void    setvehicle        (Vehicle* set);
    void    setbatt       (VehicleBatteryFactGroup* set);




signals:
    void    setidControltChanged    ();
    void    setvehicleChanged ();
    void    setbattChanged();

private:
    int    _idControl  = 10;
    Vehicle* _vehicle = nullptr;
    VehicleBatteryFactGroup* _batt=nullptr;
    int _estimate;


};

