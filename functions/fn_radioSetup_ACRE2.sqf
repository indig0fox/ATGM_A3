#include "..\defines.hpp"

if (
  !(isClass (configfile >> "CfgPatches" >> "acre_main")) ||
  !(ATGM_Settings getOrDefault ["AutoSetupRadios", true])
) exitWith {false};

// Exit if no interface, doesn't need to be set/run
if (
  !hasInterface || {_unit isEqualTo objNull}
) exitWith {false};

params [
  ["_unit", player]
];



// Ensure everyone has the radios specified in config.sqf for their side
{
  [_x, _y] params ["_side", "_radios"];
  if (playerSide isEqualTo _side) then {
    {
      _unit removeItem _x;
    } forEach (call acre_api_fnc_getCurrentRadioList);
    {
      _unit addItem _x;
    } forEach _radios;
  }

} forEach (ATGM_Settings getOrDefault ["EquipRadios_ACRE", createHashMap]);

// ACRE_PRC152
// ACRE_PRC343
// ACRE_PRC148
// ACRE_PRC152
// ACRE_PRC77
// ACRE_PRC117F

// Wait for changes to apply then tune radios
// [{
//   call acre_api_fnc_isInitialized
// }, {
//   params ["_unit"];

//   // If someone's assigned a 888S tune it
//   if (
//     [_unit, "ACRE_BF888S"] call acre_api_fnc_hasKindOfRadio
//   ) then {
//     [["ACRE_BF888S"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;
//   };

//   // If someone's assigned a 152 tune it
//   if (
//     [_unit, "ACRE_PRC152"] call acre_api_fnc_hasKindOfRadio
//   ) then {
//     [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;
//   };

//   // If someone's assigned a 117 tune it
//   if (
//     [_unit, "ACRE_PRC117F"] call acre_api_fnc_hasKindOfRadio
//   ) then {
//     [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;
//   };
// }, _unit] call CBA_fnc_waitUntilAndExecute;
