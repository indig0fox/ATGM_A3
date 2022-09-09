if (!isServer) exitWith {};

// facilitate invincibility on all entities that are inside specified safe zone markers
// every 10 seconds, check if they're in a safe zone and make them invincible (on owner machine so global effect)
// use a placeholder variable on those units so they're not being constantly reprocessed

[{
	ATGM_zones_safeZones = ["safeZone1"];
	  // run loops every 10 seconds, but scheduled so they don't impact processing time
	{
		private _unit = _x;
		private _inSafeZones = {
			_unit inArea _x
		} count (ATGM_zones_safeZones select {
			markerColor _x != ""
		});
		private _inSafeZone = _inSafeZones > 0;
		if (_inSafeZone && _x getVariable ["ATGM_zoneProtectionActive", false]) then {
			_x setVariable ["ATGM_zoneProtectionActive", true];
			[_x, false] remoteExecCall ["allowDamage", _x];

			      // if a player, send a hint to them to let them know they're entering safety
			if (_x call CBA_fnc_isPerson) then {
				if (isPlayer _x) then {
					// "You've entered the safe zone!" remoteExecCall ["hint", _x];
					[["SAFEZONES", "You are entering a friendly safe zone.", 0]] remoteExec ["BIS_fnc_EXP_camp_playSubtitles", _x];
				};
			};
		};
		if (!_inSafezone && _x getVariable ["ATGM_zoneProtectionActive", true]) then {
			_x setVariable ["ATGM_zoneProtectionActive", false];
			[_x, true] remoteExecCall ["allowDamage", _x];

			      // if a player, send a hint to them to let them know they're leaving safety
			if (_x call CBA_fnc_isPerson) then {
				if (isPlayer _x) then {
					// "You've left the safe zone!" remoteExecCall ["hint", _x];
					[["SAFEZONES", "You are leaving a friendly safe zone.", 0]] remoteExec ["BIS_fnc_EXP_camp_playSubtitles", _x];
				};
			};
		};
	} forEach allPlayers;
}, 8] call CBA_fnc_addPerFrameHandler;
