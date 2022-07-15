BRIEFING
The briefing text can be customized in description\CfgBriefing.hpp.


AUTOMATIC SUPPLY BOX FILLING
1. when a player loads in, the server gathers what magazines they have equipped in their editor loadout along with the squad they're in (detected using the RoleDescription suffix (Engineer@Alpha))
2. at each update, the server will rebroadcast the "supply box contents" variable to all machines
3. when ATGM_fnc_fillCrateFromPlayers is called, the box is filled with magazines representing the starting loadouts of each player + a small set of medical supplies
  [_this] call ATGM_fnc_fillCrateFromPlayers;

note: if Zeus Enhanced (ZEN) is loaded, a dialog will be presented to the actor that will prompt for ALL or a specific squad to fill it based off, as well as a picker that will allow them to pick 25%, 50%, 75%, or 100% resupply. The total saved count of each unique item will be reduced by the given percentage, and there will always be at least one of every saved item.


CONVERSATIONS
Use this in a trigger, and adjust to match description.ext > CfgSentences
The "selectRandom" line is going to pick a random player that's inside the trigger when it activates. This replaces the "playerEnteringTrigger" actor in conversations\rendezvous.bikb.
The ANA_1 variable is the AI speaker. If you want more than one, give them a sentence in conversations\rendezvous.bikb and add the associated variable below in CHRONOLOGICAL ORDER to match the sentences list.

```sqf
[
  "Rendezvous",
  "MyMission",
  nil,
  nil,
  nil,
  [
    selectRandom (thisList select {isPlayer _x}),
    ANA_1
  ]
] spawn BIS_fnc_kbTell;
```


ORBAT
1. Place an ORBAT group module (F5 > Strategic > ORBAT Group)
2. For the "CfgORBAT Path" field, pick an ORBAT class from description\CfgOrbat.hpp and put it in place of the last item below
  missionConfigFile >> "CfgORBAT" >> "INDAbleCompany"
  missionConfigFile >> "CfgORBAT" >> "INDAblePlatoon"
  missionConfigFile >> "CfgORBAT" >> "INDBakerPlatoon"