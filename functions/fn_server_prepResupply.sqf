if (!isServer) exitWith {};

ATGM_supplyBoxContents = createHashMap;

// listen for data from clients as they join, add to the hash, and broadcast new value
["ATGM_appendResupplyMagazines", {
  params ["_squad", "_crateMagazines"];
  ((ATGM_supplyBoxContents getOrDefault [
    _squad,
    createHashMapFromArray [
      ["magazines", []],
      ["items", []],
      ["weapons", []]
    ],
    true
  ]) get "magazines") append _crateMagazines;
  publicVariable "ATGM_supplyBoxContents";
}] call CBA_fnc_addEventHandler;

["ATGM_appendResupplyWeapons", {
  params ["_squad", "_crateWeapons"];
  ((ATGM_supplyBoxContents getOrDefault [
    _squad,
    createHashMapFromArray [
      ["magazines", []],
      ["items", []],
      ["weapons", []]
    ],
    true
  ]) get "weapons") append _crateWeapons;
  publicVariable "ATGM_supplyBoxContents";
}] call CBA_fnc_addEventHandler;

// if 60 seconds from mission start a unit with variable name N1 is present, 2x of its primary weapon will be added to any resupply box
[{!isNil "N1"}, {
  private _squad = "Standard";
  private _crateWeapons = [];
  for "_i" from 1 to 2 do {
    _crateWeapons pushBack (primaryWeapon N1);
  };
  ["ATGM_appendResupplyWeapons", [_squad, _crateWeapons]] call CBA_fnc_serverEvent;
}, [], 60] call CBA_fnc_waitUntilAndExecute;