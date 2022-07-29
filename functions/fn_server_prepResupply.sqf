#include "..\defines.hpp"

if (!isServer) exitWith {};

ATGM_supplyBoxContents = createHashMap;

// listen for data from clients as they join, add to the hash, and broadcast new value
["ATGM_appendResupplyMagazines", {
  params ["_squad", "_crateMagazines", "_playerUID"];
  if (isNil "_playerUID") then {_squad = "Standard"};

  _existingData = (ATGM_supplyBoxContents getOrDefault [
    _squad,
    createHashMap,
    false
  ]);
  
  _existingData set [
    _playerUID,
    createHashMapFromArray [
      ["magazines", _crateMagazines],
      ["items", []],
      ["weapons", []]
    ]
  ];

  ATGM_supplyBoxContents set [
    _squad,
    _existingData
  ];
  publicVariable "ATGM_supplyBoxContents";
}] call CBA_fnc_addEventHandler;

["ATGM_appendResupplyWeapons", {
  params ["_squad", "_crateWeapons"];
  if (isNil "_playerUID") then {_squad = "Standard"};

  _existingData = (ATGM_supplyBoxContents getOrDefault [
    _squad,
    createHashMap,
    false
  ]);
  
  _existingData set [
    _playerUID,
    createHashMapFromArray [
      ["magazines"],
      ["items", []],
      ["weapons", _crateWeapons]
    ]
  ];

  ATGM_supplyBoxContents set [
    _squad,
    _existingData
  ];
  publicVariable "ATGM_supplyBoxContents";
}] call CBA_fnc_addEventHandler;
