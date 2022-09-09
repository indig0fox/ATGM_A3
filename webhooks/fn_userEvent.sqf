if (!isServer) exitWith {};

if (isNil "DiscordEmbedBuilder_fnc_buildSqf") then {
	["Discord Embed Builder addon not loaded on server!"] call BIS_fnc_logFormat;
};


params ["_soldierName", "_steamProfileName", "_steamProfileUrl", "_eventText"];

[
	"ATGM_DiscordChannel", // CfgDiscordEmbedWebhooks
	"", // message
	"", // title
"", // avatar URL, doesn't work
	false, // tts
	[ // Maximum 10 embeds per message
		[
			format [
				"%1 (%2) %3",
        _soldierName,
        _steamProfileName,
				_eventText
      ], // embed title
			"", // embed description
			_steamProfileUrl, // url
			"000000", // color RGB
			true, // use timestamp
			"", // thumbnail URL
			"", // image URL
			[
				"", // author name
				"", // author url
				"" // author image
			],
			[
				format["Mission Runtime: %1", [time, "HH:MM:SS"] call BIS_fnc_secondsToString], // footer text
				"" // footer image
			],
			[ // Maximum 25 fields per embed
				[
					"Mission Name",
					briefingName,
					true  // inline
				],
				[
					"Current Admin",
					format ["%1 (%2)", _admin select 3, _admin select 5], // soldierName, steamProfileName
					true  // inline
				]
			]
		]
	]
] call DiscordEmbedBuilder_fnc_buildSqf;



/* 
_unit = player;
private _armaws = "new" call OO_ARMAWS;
private _params = [["username", name _unit], ["playeruid", getPlayerUID _unit], ["event", "join_mission"], ["unitClass", [configOf _unit] call BIS_fnc_displayName], ["primaryWeapon", getText(configFile >> "CfgWeapons" >> ((primaryWeapon player) call BIS_fnc_baseWeapon) >> "displayName")]];
["setUrl", "https// eowx1iuizib4hwh.m.pipedream.net"] call _armaws; 
_result = ["callWs", _params] call _armaws;
 */