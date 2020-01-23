/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

// Custom class to manage battery estimating time

#pragma once

#include "Vehicle.h"

#include <QObject>
#include <QTimer>
#include <QColor>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>


typedef uint8_t(*mapFn_t)(uint16_t, uint16_t, uint16_t);

//
// Plots of the functions below available at
// https://www.desmos.com/calculator/x0esk5bsrk
//

/**
 * Symmetric sigmoidal approximation
 * https://www.desmos.com/calculator/7m9lu26vpy
 *
 * c - c / (1 + k*x/v)^3
 */
static inline uint8_t sigmoidal(uint16_t voltage, uint16_t minVoltage, uint16_t maxVoltage) {
    // slow
    // uint8_t result = 110 - (110 / (1 + pow(1.468 * (voltage - minVoltage)/(maxVoltage - minVoltage), 6)));

    // steep
    // uint8_t result = 102 - (102 / (1 + pow(1.621 * (voltage - minVoltage)/(maxVoltage - minVoltage), 8.1)));

    // normal
    uint8_t result = 105 - (105 / (1 + pow(1.724 * (voltage - minVoltage)/(maxVoltage - minVoltage), 5.5)));
    return result >= 100 ? 100 : result;
}

/**
 * Asymmetric sigmoidal approximation
 * https://www.desmos.com/calculator/oyhpsu8jnw
 *
 * c - c / [1 + (k*x/v)^4.5]^3
 */
static inline uint8_t asigmoidal(uint16_t voltage, uint16_t minVoltage, uint16_t maxVoltage) {
    uint8_t result = 101 - (101 / pow(1 + pow(1.33 * (voltage - minVoltage)/(maxVoltage - minVoltage) ,4.5), 3));
    return result >= 100 ? 100 : result;
}

/**
 * Linear mapping
 * https://www.desmos.com/calculator/sowyhttjta
 *
 * x * 100 / v
 */
static inline uint8_t linear(uint16_t voltage, uint16_t minVoltage, uint16_t maxVoltage) {
    return (unsigned long)(voltage - minVoltage) * 100 / (maxVoltage - minVoltage);
}



class CustomBattery:public QObject
{
    Q_OBJECT

public:
    CustomBattery(QObject* parent = nullptr);
    ~CustomBattery();
    Q_PROPERTY(Vehicle*                     vehicle       READ vehicle        WRITE setvehicle    NOTIFY setvehicleChanged)
    Q_PROPERTY(VehicleBatteryFactGroup*     batt          READ batt           WRITE setbatt       NOTIFY setbattChanged)
    Q_PROPERTY(double                          estimate    READ estimate                           NOTIFY setestimateChanged  )
    Q_PROPERTY(double                       cellVoltage READ cellVoltage                        NOTIFY cellVoltageChanged   )
    Q_PROPERTY(int                          estimateLevel READ estimateLevel                    NOTIFY estimateLevelChanged  )
    Q_PROPERTY(int                          cellNumber  READ cellNumber     WRITE setCellNumber NOTIFY setCellNumberChanged    )


    Vehicle*                 vehicle () { return _vehicle; }
    VehicleBatteryFactGroup* batt () { return _batt; }

    void    setvehicle        (Vehicle* set);
    void    setbatt       (VehicleBatteryFactGroup* set);

    double  estimate();
    int  estimateLevel();

    double  cellVoltage();


    int    cellNumber   () { return _CellNumber; }
    void   setCellNumber( int set );



    uint8_t level(uint16_t voltage,uint16_t minVoltage, uint16_t maxVoltage,mapFn_t = linear );



signals:
    void    setidControltChanged    ();
    void    setvehicleChanged ();
    void    setbattChanged();
    void    setCellNumberChanged();
    void    setestimateChanged();
    void    cellVoltageChanged();
    void    estimateLevelChanged();


private:
    int    _cellVoltage;
    Vehicle* _vehicle = nullptr;
    VehicleBatteryFactGroup* _batt=nullptr;
    double _estimate;
    int _CellNumber;
    double _CellVoltage;
    int _estimateLevel;

    uint16_t minVoltage;
    uint16_t maxVoltage;
    mapFn_t mapFunction;

    double LIPOMIM=3.2;
    double LIPOMAX=4.2;

    enum  LIPOS {
        C1=1,  // 1 cell
        C2=2,  // 2 cell
        C3=3,  // 3 cell
        C4=4,  // 4 cell
        C5=5,  // 5 cell
        C6=6   // 6 cell
    };





};


