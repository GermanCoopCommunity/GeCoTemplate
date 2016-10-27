#include "macros.hpp"
/*
    GeCo Mission Template

    Author: joko // Jonas

    Description:
    Draw 3d Icon over players head

    Parameter(s):
    None

    Returns:
    None
*/
private _playerPos = positionCameraToWorld [0, 0, 0];
private _targets = [_playerPos, 30] call CFUNC(getNearUnits);
if (!surfaceIsWater _playerPos) then {
    private _playerPos = ATLtoASL _playerPos;
};

{
    private _target = effectiveCommander _x;
    if (!(_x in allUnitsUAV) && isPlayer _target && (_target != player || JK_Debug) && alive player) then {
        private _targetPos = visiblePositionASL _target;
        if (lineIntersects [_playerPos, _targetPos vectorAdd [0,0,1], vehicle player, _target]) exitWith {};
        private _distance = _targetPos distance _playerPos;
        private _headPosition = _target modelToWorldVisual (_target selectionPosition "pilot"); // Player head Position
        private _headPosition vectorAdd [0, 0, 0.4]; // high over the players head
        private _alpha = ((1 - 0.2 * (_distance - 8) min 1) * 0.8) max 0;

        // Cache Text, Color and Icon that dont change that fast
        private _return = [format [QGVAR(NametagsData_%1), name _target], {
            params ["_target"];
            private _isInGroup = (group _target == group player);
            private _color = if (_isInGroup) then {
                [
                    [1, 1, 1],//Main
                    [1, 0, 0.1],//Red
                    [0.1, 1, 0],//Green
                    [0.1 , 0, 1],//Blue
                    [1, 1, 0.1]//Yellow
                ] select (["MAIN","RED","GREEN","BLUE","YELLOW"] find assignedTeam _target);
            } else {
                [0.77, 0.51, 0.08]
            };

            private "_icon";
            private _text = name _target;
            if (_target in (missionNamespace getVariable ["BIS_revive_units", []])) then {
                _icon = "\A3\Ui_f\data\IGUI\Cfg\Cursors\unitbleeding_ca.paa";
                _text = _text + " (Unconscious)";
            } else {
                _icon = format ["\A3\Ui_f\data\GUI\Cfg\Ranks\%1_gs.paa", rank _x];
            };
            [_icon, _color, _text]
        }, _target, 2, QGVAR(clearNearUnits)] call CFUNC(cachedCall);

        _return params ["_icon", "_color", "_text"];
        _color pushback _alpha;
        // draw Icon
        drawIcon3D [_icon, _color, _headPosition, 0.8, 0.8, 0, _text, 2, 0.033, "PuristaMedium"];
    };
    false
} count _targets;
