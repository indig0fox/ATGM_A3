#include "..\defines.hpp"

// Exit if ACRE2 not active or tuning turned off
if (
  !isClass (configfile >> "CfgPatches" >> "acre_main") ||
  !(ATGM_Settings get "AutotuneRadios")
) exitWith {false};

// Exit if no interface, doesn't need to be set/run
if (!hasInterface) exitWith {false};

params [
  ["_unit", player]
];


ATGM_radioChannels = [
  [1, 40, "DEFAULT"],
  [2, 51, "ALPHA"],
  [3, 52, "BRAVO"],
  [4, 53, "CHARLIE"],
  [5, 54, "DELTA"],
  [6, 41, "PLATOON"],
  [7, 60, "CONVOY"],
  [8, 61, "MEDICAL"]
];

["ACRE_PRC152", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;
{
  _x params ["_chanNum", "_freq", "_name"];
  ["ACRE_PRC152", "PlatoonSetup", _chanNum, "description", _name] call acre_api_fnc_setPresetChannelField;
} forEach ATGM_radioChannels;
["ACRE_PRC152", "PlatoonSetup"] call acre_api_fnc_setPreset;


["ACRE_PRC117F", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;
{
  _x params ["_chanNum", "_freq", "_name"];
  ["ACRE_PRC117F", "PlatoonSetup", _chanNum, "description", _name] call acre_api_fnc_setPresetChannelField;
} forEach ATGM_radioChannels;
["ACRE_PRC117F", "PlatoonSetup"] call acre_api_fnc_setPreset;

if (!hasInterface || {_unit isEqualTo objNull}) exitWith {false};

[{
  call acre_api_fnc_isInitialized
}, {
  params ["_unit"];

  if ([_unit, "ACRE_PRC343"] call acre_api_fnc_hasKindOfRadio) then {
    _unit removeItem (["ACRE_PRC343"] call acre_api_fnc_getRadioByType);
  };

  // Everyone gets a 152
  if !([_unit, "ACRE_PRC152"] call acre_api_fnc_hasKindOfRadio) then {
    _unit addItem "ACRE_PRC152"; 
  };

  // Wait for changes to apply
  [{
    call acre_api_fnc_isInitialized
  }, {
    [["ACRE_PRC152"] call acre_api_fnc_getRadioByType, 1] call acre_api_fnc_setRadioChannel;

    // If someone's assigned a 117 tune it
    if ([_unit, "ACRE_PRC117F"] call acre_api_fnc_hasKindOfRadio) then {
      [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, 6] call acre_api_fnc_setRadioChannel;
    };
  }, _unit] call CBA_fnc_waitUntilAndExecute;

}, _unit] call CBA_fnc_waitUntilAndExecute;
