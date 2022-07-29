#include "..\defines.hpp"

["TFAR_event_OnRadiosReceived", {
  [{
    [player] call ATGM_fnc_radioSetup_TFAR;
  },[],1] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;