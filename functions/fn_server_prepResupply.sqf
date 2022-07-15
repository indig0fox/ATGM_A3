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
