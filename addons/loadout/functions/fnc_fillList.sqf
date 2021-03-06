#include "script_component.hpp"
/*
 * Author: NeilZar
 * Populates the listbox with magazines for the current weapon.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call zen_loadout_fnc_fillList
 *
 * Public: No
 */

params ["_display"];

private _weaponIndex = lbCurSel (_display displayCtrl IDC_WEAPON);
private _weapon = (_display getVariable QGVAR(weaponList)) select _weaponIndex;
private _filter = toLower ctrlText (_display displayCtrl IDC_SEARCH_BAR);

private _ctrlList = _display displayCtrl IDC_LIST;
lnbClear _ctrlList;

private _cfgMagazines = configFile >> "CfgMagazines";

{
    _x params ["_magazine", "_count"];

    private _displayName = getText (_cfgMagazines >> _magazine >> "displayName");

    if (_displayName isEqualTo "") then {
        _displayName = _magazine;
    };

    if (_filter in toLower _displayName) then {
        private _rounds = getNumber (_cfgMagazines >> _magazine >> "count");
        private _tooltip = format [localize LSTRING(AmmoTooltip), _displayName, _rounds, _magazine];
        private _alpha = [0.5, 1] select (_count > 0);

        private _index = _ctrlList lnbAddRow [_displayName, format [localize LSTRING(AmmoRounds), _rounds], str _count];
        _ctrlList lnbSetColor  [[_index, 0], [1, 1, 1, _alpha]];
        _ctrlList lnbSetColor  [[_index, 1], [1, 1, 1, _alpha]];
        _ctrlList lnbSetColor  [[_index, 2], [1, 1, 1, _alpha]];
        _ctrlList lbSetTooltip [_index * count lnbGetColumnsPosition _ctrlList, _tooltip];
    };
} forEach (_weapon select 2);

[_display] call FUNC(updateButtons);
