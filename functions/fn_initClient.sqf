#include "..\defines.hpp"

if (!hasInterface) exitWith {};

// Add TFAR listener
if (isClass (configfile >> "CfgPatches" >> "tfar_core") ) then {
  private _equipRadiosSetting = ATGM_Settings getOrDefault ["EquipRadios_TFAR", createHashMap];
  if !(call TFAR_fnc_haveSwRadio) then {
    if (count _equipRadiosSetting > 0 && {
      playerSide in [west, east, independent, civilian]
    }) then {
      player linkItem ((_equipRadiosSetting get playerSide) select 0);
    };
  };

  ["TFAR_event_OnRadiosReceived", {
    [
      {
        [player] call ATGM_fnc_radioSetup_TFAR;
      },
      [],
      0.5
    ] call CBA_fnc_waitAndExecute;
  }] call CBA_fnc_addEventHandler;
};


// Run if ACRE2 present and autotune enabled
if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {

  // set up Babel
  // define languages
  {
    _x call acre_api_fnc_babelAddLanguageType;
  } forEach (ATGM_settings getOrDefault ["BabelLanguages_ACRE", []]);
  // set spoken languages based on side
  {
    _x params ["_side", "_languages"];
    if (playerSide isEqualTo _side) then {
      _languages call acre_api_fnc_babelSetSpokenLanguages;
      [_languages#0] call acre_api_fnc_babelSetSpeakingLanguage;
    }
  } forEach (ATGM_settings getOrDefault ["BabelSides_ACRE", []]);
  // account for unit switches/zeus
  ["unit", {
    params ["_player"];
    {
      params ["_side", "_languages"];
      if ((side _player) isEqualTo _side) then {
        _languages call acre_api_fnc_babelSetSpokenLanguages;
        [_languages#0] call acre_api_fnc_babelSetSpeakingLanguage;
      }
    } forEach (ATGM_settings getOrDefault ["BabelSides_ACRE", []]);
  }, true] call CBA_fnc_addPlayerEventHandler;

  // set up radios
  [
    {call acre_api_fnc_isInitialized},
    {
      [player] call ATGM_fnc_radioSetup_ACRE2;
    },
    [],
    30
  ] call CBA_fnc_waitUntilAndExecute;
};