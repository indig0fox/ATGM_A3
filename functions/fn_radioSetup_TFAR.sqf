// Exit if TFAR not active
if (!isClass (configfile >> "CfgPatches" >> "tfar_core")) exitWith {false};

// Exit if no interface, doesn't need to be set/run
if (!hasInterface) exitWith {false};

params [
  ["_unit", player]
];

ATGM_longRadioChannels = [
  [1, 41, "Platoon"],
  [2, 42, "Support"],
  [3, 40, "Company"]
];

ATGM_teamRadioChannels = [
  [1, 0.1, "Red"],
  [2, 0.2, "Blue"],
  [3, 0.3, "Green"]
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
ATGM_radioSupport = [
  [1, 62, "1st support"],
  [2, 63, "2nd support"],
  [3, 64, "3rd support"],
  [4, 65, "4th support"],
  [5, 60, "Convoy"]
];


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
      _channelSettings set [0, "41"];
      _channelSettings set [1, "40"];
      _channelSettings set [2, "42"];};
    case "STG": {
      _channelSettings set [0, "42"];
      _channelSettings set [1, "41"];
      _channelSettings set [2, "40"];
    };
    case "SL": {
      _channelSettings set [0, "41"]
    };
    default {
      {
        _x params ["_chanNum", "_freq", "_name"];
        _channelSettings set [_chanNum - 1, str(_freq)];
      } forEach ATGM_longRadioChannels;
    };
  };

  _currentSettings set [2,_channelSettings];
  //Set stero mode for default channel
  _currentSettings set [3,1];

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
    case "Alpha": {_squadFreq = 51;};
    case "Bravo": {_squadFreq = 52;};
    case "Charlie": {_squadFreq = 53;};
    case "Delta": {_squadFreq = 54;};
    case "Platoon": {_squadFreq = 50;_specRole = 1;};
  };

  if (_squadFreq != 0) then {
    _channelSettings set [0, str(_squadFreq)];
    if (
      (_specRole != 1) &&
      (_role != "Medic") &&
      (_role != "SL")
    ) then {
      {
        _x params ["_chanNum", "_freq", "_name"];
        _channelSettings set [_chanNum, str(_squadFreq+_freq)];
      } forEach ATGM_teamRadioChannels;

      _channelSettings set [7, "41"];
    } else{
      if (_role == "Medic") then {
        _channelSettings set [1,"61"];
      };
    };
  } else {
    {
      _x params ["_chanNum", "_freq", "_name"];
      _channelSettings set [_chanNum - 1, str(_freq)];
    } forEach ATGM_radioSupport;
  };


  _currentSettings set [2,_channelSettings];
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