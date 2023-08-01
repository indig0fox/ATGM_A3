#include "..\defines.hpp"

// Exit if TFAR not active or tuning turned off
if (
  !isClass (configfile >> "CfgPatches" >> "tfar_core") ||
  !(ATGM_Settings getOrDefault ["AutoSetupRadios", true])
) exitWith {false};

// Exit if no interface, doesn't need to be set/run
if (!hasInterface) exitWith {false};

params [
  ["_unit", player]
];

if (isNull _unit) exitWith {
  systemChat "Failed to initialize TFAR settings, passed unit is null";
};

// Note: TFAR uses 0-indexed radio channels when updating settings, so you'll see "chanNum - 1" in places to represent the real channel number and make it more readable

if (call TFAR_fnc_haveLRRadio) then {
  private _currentSettings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
  //Set default channel
  _currentSettings set [0, 0];
  //Setup frequencies for channels 1-9
  _channelSettings = _currentSettings select 2;

  {
    _x params ["_chanNum", "_freq", "_name"];
    _channelSettings set [_chanNum - 1, _freq];
  } forEach (
    ATGM_Settings getOrDefault ["RadioChannels_TFAR_LR", []]
  );

  _currentSettings set [2, _channelSettings];
  //Set stero mode for default channel
  _currentSettings set [3, 1];

  [(call TFAR_fnc_activeLrRadio), _currentSettings] call TFAR_fnc_setLrSettings;
};

//Only setup short wave channels if player has one
if (call TFAR_fnc_haveSwRadio) then {
  _currentSettings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
  //Set default channel
  _currentSettings set [0, 0];
  //Setup frequencies for channels 1-9
  _channelSettings = _currentSettings select 2;
  
  {
    _x params ["_chanNum", "_freq", "_name"];
    _channelSettings set [_chanNum - 1, _freq];
  } forEach (
    ATGM_Settings getOrDefault ["RadioChannels_TFAR_SR", []]
  );


  _currentSettings set [2, _channelSettings];
  //Set stereo mode for default channel
  _currentSettings set [3,1];

  [(call TFAR_fnc_activeSwRadio), _currentSettings] call TFAR_fnc_setSwSettings;
};

[] spawn {
  waitUntil {!isNull findDisplay 46};
  ["<t align='center'>Radios initialized.</t>", "success", 5] call ATGM_fnc_notify;
  // SW radio
  if (call TFAR_fnc_haveSWRadio) then {
    [(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_showRadioInfo;
    sleep 5;
  };
  
  // LR radio
  if (call TFAR_fnc_haveLRRadio) then {
    [(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_showRadioInfo;
  };
};