#include "macros.hpp"
/*
    Comunity Lib - CLib

    Author: joko // Jonas

    Description:
    Init EMPS System and add Eventhandler

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(BaseMarker) = [];
DFUNC(readValue) = {
    params ["_config"];
    switch (true) do {
        case (isText _config): {
            getText _config;
        };
        case (isNumber _config): {
            getNumber _config;
        };
        case (isArray _config): {
            getArray _config;
        };
    };
};


DFUNC(convertToInAreaFormat) = {
    params ["_type", "_data"];
    switch (_type) do {
        case ("Marker"): {

        };
        case ("Area"): {

        };
        case ("Trigger"): {

        };
        case ("Location"): {

        };
    };
};

{
    private _type = (_x >> "type") call FUNC(readValue);

    GVAR(BaseMarker) pushBackUnique ([_type, _x] call FUNC(convertToInAreaFormat));
    nil
} count configProperties [missionConfigFile >> "CfgGeCo" >> "EMPS" >> "Marker", "isClass _x", true];

DFUNC(isInBase) = {
    params ["_unit", "_state"];


};


DFUNC(firedEH) = {

};
