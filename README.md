# ATGM Mission Framework

This framework is intended to provide an enhanced foundation for Zeus-controlled mission building and execution as run by ATGM. 

# FEATURES

## BRIEFING
The briefing text can be customized in `description\CfgBriefing.hpp`. It will be displayed on the "Briefing" section of the map diary.

## ACRE2 AND TFAR BETA AUTO-SETUP
Standardized platoon-net setup will be auto-configured if either addon is loaded for the server and clients. 

### ACRE2
PRC-343s will be removed, all players will have a PRC-152, and PRC-117F LR radios can be assigned to leadership in EDEN editor/placed in a box.

#### PRESET FREQUENCIES
    Channel      Label        Freq
    ===============================
    CHAN 1      DEFAULT         40
    CHAN 2      ALPHA SQD       51
    CHAN 3      BRAVO SQD       52
    CHAN 4      CHARLIE SQD     53
    CHAN 5      DELTA SQD       54
    CHAN 6      PLATOON         41
    CHAN 7      CONVOY          60
    CHAN 8      MEDICAL         61

### TFAR BETA
Radio assignment will not change. SR and LR radios will be autotuned so channels correspond to the proper frequencies for easy switching.

#### PRESET FREQUENCIES SHORT-RANGE
    Channel      Label               Freq
    =====================================
    CHAN 1      SQUAD              VARIES
    CHAN 2      RED TEAM        SQUAD+0.1
    CHAN 3      BLUE TEAM       SQUAD+0.2
    CHAN 4      GREEN TEAM      SQUAD+0.3
    CHAN 5      N/A
    CHAN 6      N/A
    CHAN 7      N/A
    CHAN 8      PLATOON                41

#### PRESET FREQUENCIES LONG-RANGE
    Channel      Label               Freq
    =====================================
    CHAN 1      PLATOON                41
    CHAN 2      SUPPORT                42
    CHAN 3      COMPANY                40
    CHAN 4      N/A
    CHAN 5      N/A
    CHAN 6      N/A
    CHAN 7      N/A
    CHAN 8      N/A



## AUTOMATIC SUPPLY & MEDICAL BOX FILLING

1. when a player loads in, the server gathers what magazines they have equipped in their editor loadout along with the squad they're in (detected using the RoleDescription suffix (Engineer@Alpha))
2. at each update, the server will rebroadcast the "supply box contents" variable to all machines
3. when ATGM_fnc_fillCrateFromPlayers is called, the box is filled with magazines representing the starting loadouts of each player + a small set of medical supplies

    ```sqf
    [_this] call ATGM_fnc_fillSupplyCrate;

    // if Zeus Enhanced is not loaded, you must use parameters
    // fill a crate with supplies from Alpha squad members
    [_this, "Alpha"] call ATGM_fnc_fillSupplyCrate;

    // fill a crate with 50% of original loadout for Bravo
    [_this, "Bravo", 0.5] call ATGM_fnc_fillSupplyCrate;
    ```

Standard, always-added items can be added to the "StandardItems" array in config.sqf

A function also exists to fill a medical crate with items defined in config.sqf.

    ```sqf
    [_this] call ATGM_fnc_fillMedicalCrate;
    ```

notes: 
- the supply logging functionality uses deduplication with PlayerUIDs, ensuring that only one set of items is saved/filled per player that joins.
- if Zeus Enhanced (ZEN) is loaded, a dialog will be presented to the actor that will prompt for ALL or a specific squad to fill it based off, as well as a picker that will allow them to pick 25%, 50%, 75%, or 100% resupply. The total saved count of each unique item will be reduced by the given percentage, and there will always be at least one of every saved item.


## CONVERSATIONS
Use the below code in a trigger, and adjust to match `description.ext > CfgSentences`

The `selectRandom` line is going to pick a random player that's inside the trigger when it activates. This replaces the `"playerEnteringTrigger"` actor in `conversations\rendezvous.bikb`.

The ANA_1 variable is the AI speaker. If you want more than one, give them a sentence in conversations\rendezvous.bikb and add the associated variable below in CHRONOLOGICAL ORDER (one entry per assigned speaker) to match the sentences list.

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


## ORBAT ON MAP
1. Place an ORBAT group module (F5 > Strategic > ORBAT Group)
2. For the "CfgORBAT Path" field, pick an ORBAT class from description\CfgOrbat.hpp and put it in place of the last item below

    ```sqf
      missionConfigFile >> "CfgORBAT" >> "INDAbleCompany"
      missionConfigFile >> "CfgORBAT" >> "INDAblePlatoon"
      missionConfigFile >> "CfgORBAT" >> "INDBakerPlatoon"
    ```

3. Optionally, you can use a lower level (Platoon) as the path and a higher level (Company) as the ceiling to 'focus' on a specific subordinate.


## VIRTUAL MORTAR STRIKE
### Intention
- A salvo of HE rounds will be fired. Upon completion, a salvo of smoke rounds will be fired.
- Both salvos will be targeted around the center of the provided trigger.

### Usage
In the OnActivation field of a trigger:
- To use defaults:

    ```sqf
    [thisTrigger] call ATGM_fnc_mortarStrike;
    ```

- To customize:
    ```sqf
    [thisTrigger, [12, 7, 150], [3, 10, 150]] call ATGM_fnc_mortarStrike;
    ```

### Parameters

    0: <object> Trigger
    1: <array> (optional)
        <number> HE Round Count
        <number> HE Delay between rounds in seconds
        <number> HE Radius of rounds around center of trigger location
    2: <array> (optional)
        <number> Smoke Round Count
        <number> Smoke Delay between rounds in seconds
        <number> Smoke Radius of rounds around center of trigger location