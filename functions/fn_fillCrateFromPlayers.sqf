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

  private _squadData = createHashMapFromArray [
    ["magazines", []],
    ["items", []],
    ["weapons", []]
  ];

  if (_squad == "All") then {
    // iterate through each key (squad) in master hash and grab all mags to add
    {
      private _hash = ATGM_supplyBoxContents get _x;
      (_squadData get "magazines") append (_hash get "magazines");
    } forEach (keys ATGM_supplyBoxContents);
  } else {
    // load from existing squad data
    _squadData = ATGM_supplyBoxContents get _squad;
  };


  _mags = (_squadData get "magazines") call BIS_fnc_consolidateArray;
  {
    _x params ["_className", "_countSaved"];
    _countToAdd = ceil(_countSaved * _supplyPercent);
    _box addItemCargoGlobal [_className, _countToAdd];
  } forEach _mags;

  _items = (_squadData get "items") call BIS_fnc_consolidateArray;
  {
    _x params ["_className", "_countSaved"];
    _countToAdd = ceil(_countSaved * _supplyPercent);
    _box addItemCargoGlobal [_className, _countToAdd];
  } forEach _items;

  // for now, the only weapons in boxes will be 2x the primary weapon of the AI unit with varname "N1" if it exists
  _weapons = ((ATGM_supplyBoxContents getOrDefault [
      "Standard",
      createHashMapFromArray [
        ["magazines", []],
        ["items", []],
        ["weapons", []]
      ],
      true
    ]) get "weapons") call BIS_fnc_consolidateArray;

  {
    _x params ["_className", "_countSaved"];
    // _countToAdd = ceil(_countSaved * _supplyPercent);
    _countToAdd = _countSaved;
    _box addWeaponCargoGlobal [_className, _countToAdd];
  } forEach _weapons;



  ["Success", "Box has been loaded to resupply """ + _squad + """.", 7] call BIS_fnc_curatorHint;
};


if (!isNil "zen_dialog_fnc_create") then {
  // PROMPT FOR SELECTION IF SIMPLEX SUPPORT SERVICES MOD IS PRESENT
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
      systemChat str _values;
      _squad = _squadsToPickFrom select _squadSelected;

      [_box, _squad, _supplyPercent] call _code;
    },
    {},
    [_box, _squadsToPickFrom, _applyChanges]
  ] call zen_dialog_fnc_create;

} else {
  // OTHERWISE RELY ON PARAMETER
  [_box, _squad] call _applyChanges;
};

