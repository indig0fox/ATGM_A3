#include "..\defines.hpp"

params [
  ["_box", objNull]
];

if (isNull _box) exitWith {
  ["No object specified", "Ensure a box is specified", 7] call BIS_fnc_curatorHint;
};

_medicalItems = ATGM_Settings get "MedicalItems";
if (isNil "_medicalItems") exitWith {
  ["Medical Items not defined", "Make sure the MedicalItems section of config.sqf is configured", 7] call BIS_fnc_curatorHint;
};

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

{
  _x params ["_className", "_countToAdd"];
  _box addItemCargoGlobal [_className, _countToAdd];
} forEach _medicalItems;

["Success", "Box has been loaded with medical supplies.", 7] call BIS_fnc_curatorHint;