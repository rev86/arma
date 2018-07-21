//
[] call compile preprocessFileLineNumbers "functions.sqf";

hint "Let the GAME begin!";

//if (isServer) then {west setFriend [west , 0];};

waituntil {!isnil "bis_fnc_init"};


if(isServer) then {

    _allLocationTypes = ["NameVillage","NameCity","NameLocal"];
    _allLocations = (nearestLocations [position player,_allLocationTypes,10000]);

    {
        _locationName = text _x;
        missionNamespace setVariable [_locationName,[["loot_spawned","false"]]];
    }forEach _allLocations;

    _loot = [] execVM "spawnLoot.sqf";

   {_res1 = [_x] execVM "stalk.sqf";} forEach allUnits;
//return fleeing bastards to battlefield
   {_res2 = [_x] spawn {
                       _bot = _this select 0;
                       if (!alive _bot) exitWith{true};
                       while {true} do {
                           sleep 60;
                           if (fleeing _bot) then {
                               hint "get your ass to the fight!";
                               _bot setBehaviour "CARELESS";
                               _bot doMove (_bot getVariable "destination");};};};
   } forEach allUnits;
//kick stucked units to their next destination
   {_res3 = [_x] spawn {
                      _bot = _this select 0;
                      if (!alive _bot) exitWith{true};
                      while {true} do {
                          _oldPos = getPos _bot;
                          sleep 360;
                          _currentPos = getPos _bot;
                          if (_oldPos distance2D _currentPos < 3) then {
                              hint format ["go go go! Your next destination is %1", _bot getVariable "destination"];
                              _bot setBehaviour "CARELESS";
                              _bot doMove (_bot getVariable "destination");};};};
   } forEach allUnits;

};


