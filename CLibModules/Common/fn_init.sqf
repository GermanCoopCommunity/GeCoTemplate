#include "macros.hpp"
/*
    GeCo Mission Template

    Author: joko // Jonas

    Description:
    Init for Common

    Parameter(s):
    None

    Returns:
    None
*/

// Disable all Radio Messages
enableSentences false;
enableRadio false;

["playerChanged", {
    (_this select 0) params ["_newPlayer"];
    _newPlayer disableConversation true;
    _newPlayer setVariable ["BIS_noCoreConversations", true];
}] call CFUNC(addEventhandler);

["entityCreated", {
    params ["_args"];
    if (_args isKindOf "CAManBase") then {
        _args disableConversation true;
        _args setVariable ["BIS_noCoreConversations", true];
    };
}] call CFUNC(addEventhandler);

// Rating system
["sideChanged", {
    (_this select 0) params ["_currentSide", "_oldSide"];

    if (_currentSide == sideEnemy) then {
        _rating = rating CLib_Player;
        CLib_Player addRating (0 - _rating);
    };
}] call CFUNC(addEventhandler);
if (isServer) then {
    ["entityCreated", {
        (_this select 0) params ["_obj"];
        {
            _x addCuratorEditableObjects [[_obj], true];
            nil
        } count allCurators
    }] call CFUNC(addEventhandler);
};
