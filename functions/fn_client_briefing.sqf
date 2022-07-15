#define COLOR_HEADER "#DDAA00"
#define COLOR_TEXT "#FFFFFF"

if (!hasInterface) exitWith {};
if (!isClass (missionConfigFile >> "CfgBriefing")) exitWith {};

private _systemTimeFormat = ["%1-%2-%3 %4:%5:%6"];
_systemTimeFormat append (systemTimeUTC apply {if (_x < 10) then {"0" + str _x} else {str _x}});

_briefingContent = [format["<font size='16' color='" + COLOR_HEADER + "' face='PuristaBold'>%1</font>", briefingName]];
_briefingContent pushBack "<br/>";
_briefingContent pushBack "<br/>";

(date call BIS_fnc_sunriseSunsetTime) params ["_sunriseTime", "_sunsetTime"];
if (!isNil "ace_weather_fnc_calculateTemperatureAtHeight") then {
  _briefingContent pushBack format ["Temperature ASL: %1 C", 0 call ace_weather_fnc_calculateTemperatureAtHeight];
  _briefingContent pushBack "<br/>";
};
_briefingContent pushBack format ["Wind: %1 at %2", windDir, windStr];
_briefingContent pushBack "<br/>";
_briefingContent pushBack format ["Sunrise: %1 | Sunset: %2", [_sunriseTime, "HH:MM"] call BIS_fnc_timeToString, [_sunsetTime, "HH:MM"] call BIS_fnc_timeToString];
_briefingContent pushBack "<br/>";
_briefingContent pushBack format ["Moon Fullness: %1%2", ceil(moonPhase date* 100), "%"];
_briefingContent pushBack "<br/>";
_briefingContent pushBack "<br/>";

_backgroundText = getText(missionConfigFile >> "CfgBriefing" >> "Background");
if (_backgroundText != "") then {
  _briefingContent pushBack "<font size='18' color='" + COLOR_HEADER + "' face='PuristaBold'>BACKGROUND</font>";
  _briefingContent pushBack "<br/>";
  if (!isNil "CBA_fnc_sanitizeHTML") then {
    _briefingContent pushBack (_backgroundText call CBA_fnc_sanitizeHTML);
  } else {
    _briefingContent pushBack (_backgroundText);
  };
  _briefingContent pushBack "<br/>";
};

_briefingContent pushBack "<br/>";
_briefingContent pushBack "<br/>";

_missionText = getText(missionConfigFile >> "CfgBriefing" >> "Mission");
if (_missionText != "") then {
  _briefingContent pushBack "<font size='18' color='" + COLOR_HEADER + "' face='PuristaBold'>MISSION</font>";
  _briefingContent pushBack "<br/>";
  if (!isNil "CBA_fnc_sanitizeHTML") then {
    _briefingContent pushBack (_missionText call CBA_fnc_sanitizeHTML);
  } else {
    _briefingContent pushBack (_missionText);
  };
  _briefingContent pushBack "<br/>";
};

player createDiaryRecord ["Diary",
  [
    "Briefing",
    _briefingContent joinString ""
  ]
];