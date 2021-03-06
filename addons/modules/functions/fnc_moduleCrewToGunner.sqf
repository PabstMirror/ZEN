#include "script_component.hpp"
/*
 * Author: Ampersand
 * Zeus module function to have AI crew take the place of an incapacitated gunner.
 *
 * Arguments:
 * 0: Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call zen_modules_fnc_moduleCrewToGunner
 *
 * Public: No
 */

params ["_logic"];

private _vehicle = attachedTo _logic;
deleteVehicle _logic;

if (isNull _vehicle) exitWith {
    [LSTRING(NoObjectSelected)] call EFUNC(common,showMessage);
};

if (!alive _vehicle) exitWith {
    [LSTRING(OnlyAlive)] call EFUNC(common,showMessage);
};

if (fullCrew [_vehicle, "gunner", true] isEqualTo []) exitWith {
    [LSTRING(MustHaveGunner)] call EFUNC(common,showMessage);
};

_vehicle allowCrewInImmobile true;

private _gunner = gunner _vehicle;
private _newGunners = (crew _vehicle - [_gunner]) select {lifeState _x in ["HEALTHY", "INJURED"]};

if (!isNull _gunner) then {
    moveOut _gunner;
};

if (_newGunners isEqualTo []) exitWith {
    [LSTRING(NoCrewAvailable)] call EFUNC(common,showMessage);
};

private _newGunner = _newGunners select (count _newGunners - 1);
[QGVAR(moveToGunner), [_newGunner, _vehicle], _newGunner] call CBA_fnc_targetEvent;
