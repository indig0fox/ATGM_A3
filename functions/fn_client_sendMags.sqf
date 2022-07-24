if (!hasInterface) exitWith {};

[{!isNull player}, {
  private _unit = player;
  private _crateMagazines = [];
  private _squad = "";
  if ((roleDescription _unit) isNotEqualTo "") then {
    if ((roleDescription _unit) find '@' > -1) then {
      _squad = ((roleDescription _unit) splitString '@') select 1;
    };
  } else {_squad = "Other"};

  _crateMagazines append (magazines _unit);
  _crateMagazines append (primaryWeaponMagazine _unit);
  if (secondaryWeapon _unit != "") then {_crateMagazines append (secondaryWeaponMagazine _unit)};

  systemChat "RESUPPLY SYSTEM: Gathered loadout info";

  ["ATGM_appendResupplyMagazines", [_squad, _crateMagazines]] call CBA_fnc_serverEvent;
}] call CBA_fnc_waitUntilAndExecute