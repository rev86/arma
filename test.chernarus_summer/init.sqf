//
[] call compile preprocessFileLineNumbers "functions.sqf";

hint "Let the GAME begin!";

//if (isServer) then {west setFriend [west , 0];};

{_res = [_x] execVM "stalk.sqf";} forEach allUnits;
