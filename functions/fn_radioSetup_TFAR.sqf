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

params [
  ["_unit", player]
];

if !(_unit isEqualType objNull) then {
  _unit = player;
};

if (!isClass (configfile >> "CfgPatches" >> "tfar_core")) exitWith {false};


if (call TFAR_fnc_haveLRRadio) then {
  private _currentSettings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
  //Set default channel
  _currentSettings set [0, 6 - 1];
  //Setup frequencies for channels 1-9
  _channelSettings = _currentSettings select 2;

  {
    _x params ["_chanNum", "_freq", "_name"];
    _channelSettings set [_chanNum - 1, str(_freq)];
  } forEach ATGM_radioChannels;

  _currentSettings set [2,_channelSettings];
  //Set stero mode for default channel
  _currentSettings set [3,1];
  [(call TFAR_fnc_activeLrRadio), _currentSettings] call TFAR_fnc_setLrSettings;
};

//Only setup short wave channels if player has one
if (call TFAR_fnc_haveSwRadio) then {
  _currentSettings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
  //Set default channel
  _currentSettings set [0, 1 - 1];
  //Setup frequencies for channels 1-9
  _channelSettings = _currentSettings select 2;

  {
    _x params ["_chanNum", "_freq", "_name"];
    _channelSettings set [_chanNum - 1, str(_freq)];
  } forEach ATGM_radioChannels;

  _currentSettings set [2,_channelSettings];
  //Set stero mode for default channel
  _currentSettings set [3,1];

  [(call TFAR_fnc_activeSwRadio), _currentSettings] call TFAR_fnc_setSwSettings;
};

["TFAR_event_OnRadiosReceived", {
  [{
    call ATGM_fnc_radioSetup_TFAR;
  },[],1] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;