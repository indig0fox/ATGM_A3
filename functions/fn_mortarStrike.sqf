/*
  Intention:
    A salvo of HE rounds will be fired. Upon completion, a salvo of smoke rounds will be fired.
    Both salvos will be targeted around the center of the provided trigger.

  Usage:
    In the OnActivation field of a trigger:
      To use defaults:
        [thisTrigger] call ATGM_fnc_mortarStrike;
      To customize:
        [thisTrigger, [12, 7, 150], [3, 10, 150]] call ATGM_fnc_mortarStrike;

  Params:
    0: <object> Trigger
    1: <array> (optional)
      <number> HE Round Count
      <number> HE Delay between rounds in seconds
      <number> HE Radius of rounds around center of trigger location
    2: <array> (optional)
      <number> Smoke Round Count
      <number> Smoke Delay between rounds in seconds
      <number> Smoke Radius of rounds around center of trigger location
*/
#include "..\defines.hpp"

[_this] spawn {
  params [
    ["_triggerObj", objNull],
    ["_HEParams", [12, 7, 150]],
    ["_SmokeParams", [6, 7, 150]]
  ];

  if (isNull _triggerObj) exitWith {};

  _HEParams params ["_HERounds", "_HEDelay", "_HERadius"];
  _SmokeParams params ["_SmokeRounds", "_SmokeDelay", "_SmokeRadius"];

  sleep 3;

  if (_HERounds > 0) then {
    [
      getPos _triggerObj,
      "Sh_82mm_AMOS",
      _HERadius,
      _HERounds,
      _HEDelay,
      {false},
      0,
      250,
      150,
      [""]
    ] spawn BIS_fnc_fireSupportVirtual;
  };

  if (_SmokeRounds > 0) then {
    [{
      params ["_triggerObj", "_SmokeRounds", "_SmokeDelay", "_SmokeRadius"];
      [
        getPos _triggerObj,
        "Smoke_82mm_AMOS_White",
        _SmokeRadius,
        _SmokeRounds,
        _SmokeDelay,
        {false},
        0,
        250,
        150,
        [""]
      ] spawn BIS_fnc_fireSupportVirtual;
    }, [_triggerObj, _SmokeRounds, _SmokeDelay, _SmokeRadius], _HERounds * _HEDelay] call CBA_fnc_waitAndExecute;
  };
};
