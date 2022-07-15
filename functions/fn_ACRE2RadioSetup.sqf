params [
  ["_unit", player]
];

if !(_unit isEqualType objNull) then {
  _unit = player;
};

if (!isClass (configfile >> "CfgPatches" >> "acre_main")) exitWith {false};

#define DEFAULTCHANNEL 1
#define ALPHACHANNEL 2
#define BRAVOCHANNEL 3
#define CHARLIECHANNEL 4
#define DELTACHANNEL 5
#define PLATOONCHANNEL 6

["ACRE_PRC152", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;

["ACRE_PRC152", "PlatoonSetup", DEFAULTCHANNEL, "description", "DEFAULT"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", ALPHACHANNEL, "description", "ALPHA SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", BRAVOCHANNEL, "description", "BRAVO SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", CHARLIECHANNEL, "description", "CHARLIE SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", DELTACHANNEL, "description", "DELTA SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", PLATOONCHANNEL, "description", "PLATOON"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", 7, "description", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC152", "PlatoonSetup", 8, "description", "FIRES"] call acre_api_fnc_setPresetChannelField;

["ACRE_PRC152", "PlatoonSetup"] call acre_api_fnc_setPreset;


["ACRE_PRC117F", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;

["ACRE_PRC117F", "PlatoonSetup", DEFAULTCHANNEL, "description", "DEFAULT"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", ALPHACHANNEL, "description", "ALPHA SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", BRAVOCHANNEL, "description", "BRAVO SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", CHARLIECHANNEL, "description", "CHARLIE SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", DELTACHANNEL, "description", "DELTA SQD"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", PLATOONCHANNEL, "description", "PLATOON"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", 7, "description", "CAS"] call acre_api_fnc_setPresetChannelField;
["ACRE_PRC117F", "PlatoonSetup", 8, "description", "FIRES"] call acre_api_fnc_setPresetChannelField;

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
      [["ACRE_PRC117F"] call acre_api_fnc_getRadioByType, PLATOONCHANNEL] call acre_api_fnc_setRadioChannel;
    };
  }, _unit] call CBA_fnc_waitUntilAndExecute;

}, _unit] call CBA_fnc_waitUntilAndExecute;
