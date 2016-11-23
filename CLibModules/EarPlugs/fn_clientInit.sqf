#include "macros.hpp"
/*
    GeCo Mission Template

    Author: joko // Jonas

    Description:
    Init for EarPlugs

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(soundVolumeReduced) = false;
GVAR(oldVolume) = soundVolume;
[
    "EarPlugs In",
    CLib_Player,
    0,
    {!GVAR(soundVolumeReduced)},
    {
        GVAR(oldVolume) = soundVolume;
        GVAR(soundVolumeReduced) = true;
        0.5 fadeSound (soundVolume*0.7);
    }
] call CFUNC(addAction);

[
    "EarPlugs Out",
    CLib_Player,
    0,
    {GVAR(soundVolumeReduced)},
    {
        GVAR(soundVolumeReduced) = false;
        0.5 fadeSound GVAR(oldVolume);
    }
] call CFUNC(addAction);

["playerChanged", {
    GVAR(soundVolumeReduced) = false;
    0.5 fadeSound GVAR(oldVolume);
}] call CFUNC(addEventhandler);
