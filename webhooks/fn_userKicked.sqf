if (!isServer) exitWith {};

if (isNil "DiscordEmbedBuilder_fnc_buildSqf") then {
	["Discord Embed Builder addon not loaded on server!"] call BIS_fnc_logFormat;
};


params ["_soldierName", "_steamProfileName", "_steamProfileUrl", "_eventText", "_kickReason"];

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
			"FF0000", // color RGB
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
				],
				[
					"Kick Reason",
					_kickReason,
					false
				]
			]
		]
	]
] call DiscordEmbedBuilder_fnc_buildSqf;