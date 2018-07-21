_bot = _this select 0;

_position = 0;
_name = 1;
_plannedLocations = [];

_aeroPosition = getMarkerPos "aero";
_azimuthToAero = _bot getDir _aeroPosition;
_distanceToAero = _bot distance2D _aeroPosition;

_closestVillages = [_bot, 50, _distanceToAero, "false"] call fncGetAll;
//plan our route: determine places to visit
{
    _townPosition = (position _x);
    _townName = (text _x);
    _azimuth = _bot getDir _townPosition;

    if (abs(_azimuthToAero - _azimuth) < 30) then {
        _plannedLocations pushBack _x;

        _m4 = createMarker[format ["%1", _townName], _townPosition];
        _m4 setMarkerShape "ICON";
        _m4 setMarkerType "hd_dot";
        _m4 setMarkerColor "ColorRed";
    };

}forEach _closestVillages;
//loop trough planned locations
{
    _plannedLocationPos = position _x;
    //spawn loot
    //if ((_x getVariable "loot_spawned") != "true") then
    //{
    //    [_x, 300] execVM "spawnLoot.sqf";

    //};
    //_bot disableAI "AUTOTARGET";
    //_bot setCombatMode "GREEN";
    _bot doMove _plannedLocationPos;
    _bot setVariable["destination", _plannedLocationPos];

    waitUntil {_bot distance2D _plannedLocationPos < 15};

    hint "arrived!";

    _buildings = nearestObjects [_bot, ["building"], 300];
    _buildingsCount = count _buildings;
    _counter = 0;
    _enterableBuildings = [];
    _nBuilding = [];
//find enterable buildings
    while {_counter < _buildingsCount} do
    {
        sleep 0.01;
        _isEnterable = false;
        _nBuilding = (_buildings select _counter);
        //_isEnterable = [_nBuilding] call BIS_fnc_isBuildingEnterable;
        if([_nBuilding] call fncBuildingHasDoors) then
        {
           _enterableBuildings pushBack _nBuilding;
        };
        _counter = _counter + 1;
    };
//randomize order of buidings
    _enterableBuildings = _enterableBuildings call BIS_fnc_arrayShuffle;

//stalk trough buildings
    hint str(count _enterableBuildings);
    _i = 0;
    {
       sleep 1;
       _bot disableAI "AUTOTARGET";
       //_bot setCombatMode "GREEN";
       _j = 0;
       hint format["Going to house %1", _i];
       _bot doMove (getPosATL _x);
       _bot setVariable["destination", getPosATL _x];
       waitUntil {_bot distance2D _x < 10};
       hint format["arriving at house %1", _i];
       _allBuildingPositions = _x buildingPos -1;
       //_looting = [_bot,_allBuildingPositions] call compile preprocessFile "gatherBuildingLoot.sqf";
       _looting = [_bot,_allBuildingPositions] execVM "gatherBuildingLoot.sqf";
       waitUntil {scriptDone _looting };
       _i = _i + 1;

    }forEach _enterableBuildings;

}forEach _plannedLocations;








