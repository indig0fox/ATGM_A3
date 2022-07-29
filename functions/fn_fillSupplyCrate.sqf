/*
  Intention:
    When a player joins a mission, their equipped magazine items (mags, grenades) will be stored.
    Their gear will be grouped with other squadmates (based on RoleDescription @ suffix of their unit).

  Usage:
    In ZEN edit interface, Local or Target Exec

    To fill a box with gear from all squads:
      [_this] call ATGM_fnc_fillCrateFromPlayers;

    To fill a box with gear for Alpha or Bravo:
      [_this, "Alpha"] call ATGM_fnc_fillCrateFromPlayers;
      [_this, "Bravo"] call ATGM_fnc_fillCrateFromPlayers;
    
  Params:
    0: <object> the box/vehicle to fill
    1: <string> (optional) the squad to make the box for
*/
#include "..\defines.hpp"

params [
  ["_box", objNull],
  ["_squad", "All"]
];

if (isNull _box) exitWith {
  ["No object specified", "Ensure a box is specified", 7] call BIS_fnc_curatorHint;
};
if (isNil "ATGM_supplyBoxContents") exitWith {};



// this function takes params of the box to fill, the squad to fill it for (or ALL), and optional supply percentage
private _applyChanges = {
  params ["_box", "_squad", ["_supplyPercent", 1, [1]]];

  if (_squad != "All" && isNil {ATGM_supplyBoxContents get _squad}) exitWith {
    ["No Data", "No data logged for squad """ + _squad + """.", 7] call BIS_fnc_curatorHint;
  };

  clearWeaponCargoGlobal _box;
  clearMagazineCargoGlobal _box;
  clearItemCargoGlobal _box;
  clearBackpackCargoGlobal _box;

  private _addItems = {
    params [
      "_hashToParse",
      ["_supplyPercent", 1]
    ];

    {
      [_x, _y] params ["_playerUID", "_unitData"];
      {
        private _itemCategory = _x;
        private _items = (_unitData get _itemCategory) call BIS_fnc_consolidateArray;
        {
          _x params ["_className", "_countSaved"];
          _countToAdd = ceil(_countSaved * _supplyPercent);
          _box addItemCargoGlobal [_className, _countToAdd];
        } forEach _items;
      } forEach ["weapons", "magazines", "items"];
    } forEach _hashToParse;
  };


  // Add items for all squads or specific one
  if (_squad == "All") then {
    // iterate through each key (squad) in master hash and grab all mags to add
    {
      private _hash = ATGM_supplyBoxContents get _x;
      [_hash, _supplyPercent] call _addItems;
    } forEach (keys ATGM_supplyBoxContents);
  } else {
    // load from existing squad data
    _squadData = ATGM_supplyBoxContents get _squad;
    [_squadData, _supplyPercent] call _addItems;
  };


  // standard weapons and items for all boxes
  {
    _x params ["_className", "_countToAdd"];
    _box addItemCargoGlobal [_className, _countToAdd];
  } forEach (ATGM_Settings get "StandardItems");

  ["Success", "Box has been loaded to resupply """ + _squad + """.", 7] call BIS_fnc_curatorHint;
};


if (isNil "zen_dialog_fnc_create") then {
  // RELY ON PARAMETER
  [_box, _squad, _supplyPercent] call _applyChanges;
} else {
  // PROMPT FOR SELECTION IF ZEUS ENHANCED MOD IS PRESENT
  private _squadsToPickFrom = ["All"] + (keys ATGM_supplyBoxContents);

  [
    "SUPPLY BOX - SELECT SQUAD",
    [
      [
        "COMBO",
        "Squad Selection",
        [
          _squadsToPickFrom apply {_squadsToPickFrom find _x},
          _squadsToPickFrom apply {
            [
              _x,
              "",
              getText(configFile >> "CfgMarkers" >> ("loc_Letter" + (_x select [0, 1])) >> "icon")
            ]
          },
          0
        ]
      ],
      [
        "COMBO",
        "Portion of Original Supplies",
        [
          [0.25, 0.5, 0.75, 1],
          ["25%", "50%", "75%", "100%"],
          3
        ]
      ]
    ],
    {
      params ["_values","_args"];
      _values params ["_squadSelected", "_supplyPercent"];
      _args params ["_box", "_squadsToPickFrom", "_code"];
      // systemChat str _values;
      _squad = _squadsToPickFrom select _squadSelected;

      [_box, _squad, _supplyPercent] call _code;
    },
    {},
    [_box, _squadsToPickFrom, _applyChanges]
  ] call zen_dialog_fnc_create;
};
