// call ATGM_webhooks_fnc_attendanceReport;

if (!isServer) exitWith {};

if (isNil "DiscordEmbedBuilder_fnc_buildSqf") then {
	["Discord Embed Builder addon not loaded on server!"] call BIS_fnc_logFormat;
};

_users = allUsers;
// https// community.bistudio.com/wiki/getUserInfo
_usersInfo = [];
{
	_usersInfo pushBack (getUserInfo _x);
} forEach _users;

private _adminInfo = "";
if (count _usersInfo > 0) then {
	_adminUser = _usersInfo select {
		(_x select 8) > 0 || (_x select 1) == 2
	};
	if (count _adminUser > 0) then {
		_selected = _adminUser select 0;
_adminInfo = format ["%1 (%2)", _selected select 3, _selected select 5]; // soldierName, steamProfileName
	};
};


if (_adminInfo isEqualTo "") then {
	_adminInfo = "N/A"
};

// _userInfo params ["_playerID", "_ownerId", "_playerUID", "_profileName", "_displayName", "_steamName", "_clientState", "_isHC", "_adminState", "_networkInfo", "_unit"];
// _networkInfo params ["_avgPing", "_avgBandwidth", "_desync"];

[
	"ATGM_DiscordChannel", // CfgDiscordEmbedWebhooks
	"", // message
	"", // title
"", // avatar URL, doesn't work
	false, // tts
	[ // Maximum 10 embeds per message
		[
			"Attendance Report", // embed title
			"", // embed description
			"", // url
			"FFFF00", // color RGB
			true, // use timestamp
			ATGM_LOGO_WEB, // thumbnail URL
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
					_adminInfo,
					true  // inline
				],
				[
					"Players Present",
					((_usersInfo apply {
						format[
							"%1 (%2 ms)",
							_x select 3,
							_x select 9 select 0
						]
					}) joinString '<br/>')
				]
			]
		]
	]
] call DiscordEmbedBuilder_fnc_buildSqf;

true