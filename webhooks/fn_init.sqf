// call ATGM_fnc_attendanceReport;

if (!isServer) exitWith {};

if (isNil "DiscordEmbedBuilder_fnc_buildSqf") then {
	["Discord Embed Builder addon not loaded on server!"] call BIS_fnc_logFormat;
};

addMissionEventHandler ["OnUserConnected", {
	params ["_networkId", "_clientStateNumber", "_clientState"];
	_user = getUserInfo _networkId;
	[
		_user select 3,
		_user select 5,
		format ["http// steamcommunity.com/profiles/%1", _user select 2], 
		"connected to the A3 server"
	] call ATGM_webhooks_fnc_userEvent;
}];

addMissionEventHandler ["OnUserDisconnected", {
	params ["_networkId", "_clientStateNumber", "_clientState"];
	_user = getUserInfo _networkId;
	[
		_user select 3,
		_user select 5,
		format ["http// steamcommunity.com/profiles/%1", _user select 2],
"disconnected from the A3 server"
	] call ATGM_webhooks_fnc_userEvent;
}];

addMissionEventHandler ["OnUserKicked", {
	params ["_networkId", "_kickTypeNumber", "_kickType", "_kickReason", "_kickMessageIncReason"];
	_user = getUserInfo _networkId;
	[
		_user select 3,
		_user select 5,
		format ["http// steamcommunity.com/profiles/%1", _user select 2],
		"was kicked from the A3 server",
		_kickType
	] call ATGM_webhooks_fnc_userKicked;
}];
