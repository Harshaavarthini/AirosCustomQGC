/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#ifndef APMFirmwarePluginFactory_H
#define APMFirmwarePluginFactory_H

#include "FirmwarePlugin.h"

class ArduCopterFirmwarePlugin;
class ArduPlaneFirmwarePlugin;
class ArduRoverFirmwarePlugin;
class ArduSubFirmwarePlugin;

class CustomFirmwarePluginFactory : public FirmwarePluginFactory
{
    Q_OBJECT

public:
    CustomFirmwarePluginFactory(void);

    QList<MAV_AUTOPILOT>    supportedFirmwareTypes      (void) const final;
    FirmwarePlugin*         firmwarePluginForAutopilot  (MAV_AUTOPILOT autopilotType, MAV_TYPE vehicleType) final;

private:
    ArduCopterFirmwarePlugin*   _arduCopterPluginInstance;
    ArduPlaneFirmwarePlugin*    _arduPlanePluginInstance;
    ArduRoverFirmwarePlugin*    _arduRoverPluginInstance;
    ArduSubFirmwarePlugin*      _arduSubPluginInstance;
};

#endif
//extern CustomFirmwarePluginFactory CustomFirmwarePluginFactoryImp;
