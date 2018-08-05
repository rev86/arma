//
[] call compile preprocessFileLineNumbers "functions.sqf";

hint "Let the GAME begin!";

//if (isServer) then {west setFriend [west , 0];};

waituntil {!isnil "bis_fnc_init"};


if(isServer) then {

    _allUnits = allUnits select {faction _x != "Ryanzombiesfaction"};

    _allLocationTypes = ["NameVillage","NameCity","NameLocal"];
    _allLocations = (nearestLocations [position player,_allLocationTypes,10000]);

    {
        _locationName = text _x;
        _lootVar = _locationName + "_lootSpawned";
        _zombiesVar = _locationName + "_zombiesSpawned";
        missionNamespace setVariable [_lootVar,"false"];
        missionNamespace setVariable [_zombiesVar,"false"];
    }forEach _allLocations;

    _loot = [] execVM "spawnLoot.sqf";
    _zombies = [] execVM "spawnZombies.sqf";

    {_res1 = [_x] execVM "stalk.sqf";} forEach _allUnits;
//return fleeing bastards to battlefield
   {_res2 = [_x] spawn {
                       _bot = _this select 0;
                       if (!alive _bot) exitWith{true};
                       while {true} do {
                           sleep 60;
                           _nearEntities = _bot nearEntities 300;
                           _nearZombies = _nearEntities select {faction _x == "Ryanzombiesfaction"};

                           if (fleeing _bot && count _nearZombies == 0) then {
                               hint "get your ass to the fight!";
                               _bot setBehaviour "CARELESS";
                               _bot doMove (_bot getVariable "destination");};};};
   } forEach _allUnits;
   //clear abandoned zombies
  {_res21 = [_x] spawn {
                       _location = _this select 0;
                       while {true} do {
                          _locationName = text _location;
                          _zombiesVar = _locationName + "_zombiesSpawned";
                          _locationZombiesSpawned = missionNamespace getVariable _zombiesVar;
                          if (_locationZombiesSpawned == "true" && count (((position _location) nearEntities 200) select {faction _x != "Ryanzombiesfaction"}) == 0) then
                          {
                            _nearEntities = (position _location) nearEntities 200;
                            _nearZombies = _nearEntities select {faction _x == "Ryanzombiesfaction"};
                            {
                                deleteVehicle _x;
                            } forEach _nearZombies;
                            missionNamespace setVariable [_zombiesVar,"false"];
                            hint format ["Zombies removed from location %1", _locationName];
                          };
                          sleep 10;
                       };
                      };
  } forEach _allLocations;
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
   } forEach _allUnits;

};


