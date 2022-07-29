#include "..\defines.hpp"

// Exit if TFAR not active or tuning turned off
if (
  !isClass (configfile >> "CfgPatches" >> "tfar_core") ||
  !(ATGM_Settings get "AutotuneRadios")
) exitWith {false};

// Exit if no interface, doesn't need to be set/run
if (!hasInterface) exitWith {false};

params [
  ["_unit", player]
];

// Note: TFAR uses 0-indexed radio channels when updating settings, so you'll see "chanNum - 1" in places to represent the real channel number and make it more readable


if (isNull _unit) exitWith {
  systemChat "Failed to initialize TFAR settings, passed unit is null";
};

private _squad = "Other";
private _role = "Other";
if !(isNull _unit) then {
  private _unit = player;
  if ((roleDescription _unit) isNotEqualTo "") then {
    if ((roleDescription _unit) find '@' > -1) then {
      ((roleDescription _unit) splitString '@') params [
        ["_rawRole", "Other", [""]],
        ["_rawSquad", "Other", [""]]
      ];
      _role = _rawRole;
      _squad = _rawSquad;
    };
  };
};

if (_role in ["Commander", "Pilot", "Gunner", "Driver"]) then {
  _role = "STG";
};


if (call TFAR_fnc_haveLRRadio) then {
  private _currentSettings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
  //Set default channel
  _currentSettings set [0, 0];
  //Setup frequencies for channels 1-9
  _channelSettings = _currentSettings select 2;
  switch (_role) do {
     case "PL": {
      _channelSettings set [1 - 1, str(RADIO_PLATOON)];
      _channelSettings set [2 - 1, str(RADIO_COMPANY)];
      _channelSettings set [3 - 1, str(RADIO_SUPPORT0)];
    };
    case "STG": {
      _channelSettings set [1 - 1, str(RADIO_SUPPORT0)];
      _channelSettings set [2 - 1, str(RADIO_PLATOON)];
      _channelSettings set [3 - 1, str(RADIO_COMPANY)];
    };
    case "SL": {
      _channelSettings set [1 - 1, str(RADIO_PLATOON)]
    };
    default {
      {
        _x params ["_chanNum", "_freq", "_name"];
        _channelSettings set [_chanNum - 1, str(_freq)];
      } forEach (ATGM_Settings get "RadioChannels_LR");
    };
  };

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
  private _squadFreq = 0;
  private _specRole = 0;
  switch (_squad) do {
    case "Alpha": {_squadFreq = RADIO_ALPHA;};
    case "Bravo": {_squadFreq = RADIO_BRAVO;};
    case "Charlie": {_squadFreq = RADIO_CHARLIE;};
    case "Delta": {_squadFreq = RADIO_DELTA;};
    case "Platoon": {_squadFreq = RADIO_PLATOON; _specRole = 1;};
  };

  if (_squadFreq != 0) then {
    _channelSettings set [0, str(_squadFreq)];
    if (
      (_specRole != 1) &&
      (_role != "Medic")
    ) then {
      {
        _x params ["_chanNum", "_freq", "_name"];
        _channelSettings set [_chanNum - 1, str(_squadFreq + _freq)];
      } forEach (ATGM_Settings get "RadioChannels_SR");

      _channelSettings set [8 - 1, str(RADIO_PLATOON)];
    } else {
      if (_role == "Medic") then {
        _channelSettings set [2 - 1, str(RADIO_MEDICAL)];
      };
    };
  } else {
    {
      _x params ["_chanNum", "_freq", "_name"];
      _channelSettings set [_chanNum - 1, str(_freq)];
    } forEach (ATGM_Settings get "RadioChannels_Support");
  };


  _currentSettings set [2, _channelSettings];
  //Set stero mode for default channel
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