#include "..\defines.hpp"
#include "..\config.sqf"


// Define ACRE radio presets by model
if (isClass (configfile >> "CfgPatches" >> "acre_main") ) then {
	// Configure PRC152
	["ACRE_PRC152", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;
	{
		_x params ["_chanNum", "_name"];
		[
			"ACRE_PRC152",
			"PlatoonSetup",
			_chanNum,
			"description",
			_name
		] call acre_api_fnc_setPresetChannelField;
	} forEach (
		ATGM_Settings getOrDefault ["RadioChannels_ACRE", []]
	);

	["ACRE_PRC152", "PlatoonSetup"] call acre_api_fnc_setPreset;
	//////////////

	// Configure PRC148
	["ACRE_PRC148", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;
	{
		_x params ["_chanNum", "_name"];
		[
			"ACRE_PRC148",
			"PlatoonSetup",
			_chanNum,
			"label",
			_name
		] call acre_api_fnc_setPresetChannelField;
	} forEach (
		ATGM_Settings getOrDefault ["RadioChannels_ACRE", []]
	);

	["ACRE_PRC148", "PlatoonSetup"] call acre_api_fnc_setPreset;


	// Configure PRC117F (backpack)
	["ACRE_PRC117F", "default", "PlatoonSetup"] call acre_api_fnc_copyPreset;
	{
		_x params ["_chanNum", "_name"];
		[
			"ACRE_PRC117F",
			"PlatoonSetup",
			_chanNum,
			"name",
			_name
		] call acre_api_fnc_setPresetChannelField;
	} forEach (
		ATGM_Settings getOrDefault ["RadioChannels_ACRE", []]
	);

	["ACRE_PRC117F", "PlatoonSetup"] call acre_api_fnc_setPreset;
};