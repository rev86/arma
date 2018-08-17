_zombies = [
"RyanZombie31walker",
"RyanZombie27walker",
"RyanZombie23walker",
"RyanZombieC_man_polo_4_Fwalker",
"RyanZombieC_man_polo_5_Fwalker",
"RyanZombieC_man_polo_6_Fwalker",
"RyanZombieC_man_p_fugitive_Fwalker",
"RyanZombieC_man_w_worker_Fwalker"
];

_allLocationTypes = ["NameVillage","NameCity","NameLocal"];
_allLocations = (nearestLocations [position player,_allLocationTypes,10000]);

_radius  = 400;
_spawnZombiesDistance = 200;
_allUnits = allUnits select {faction _x != "Ryanzombiesfaction"};

while {true} do
{
 sleep 10;
 {
    _locationName = text _x;
    _locationPos = position _x;
    _zombiesVar = _locationName + "_zombiesSpawned";
    _locationZombiesSpawned = missionNamespace getVariable _zombiesVar;
    _unitsInLocation = "false";

    {if (_x  distance2D _locationPos < _spawnZombiesDistance) exitWith{_unitsInLocation = "true";}} forEach _allUnits;

    if ( _locationZombiesSpawned != "true" && _unitsInLocation == "true") then
    {
        _houseArray = _locationPos nearObjects ["building",_radius];
        _houseArray = _houseArray call BIS_fnc_arrayShuffle;
        //spawn only on 1% of houses + 1 house
        _zHouses = _houseArray select [0,1+floor(random((count _houseArray)*0.01))];
        hint format ["Will fill %1 houses from %2",count _zHouses,count _houseArray];
        //_zHouses = _houseArray select [0,1];

        {
            _spawnPos = (getPosATL _x) findEmptyPosition [1,10];
            if (count _spawnPos > 0) then
            {
                _zUnits = _zombies select [0,floor(random((count _zombies)-1))];
                _zGroup = [ _spawnPos, INDEPENDENT, _zUnits,[],[],[],[],[],floor (random 360)] call BIS_fnc_spawnGroup;
                [_zGroup,_locationPos,300]  call bis_fnc_taskPatrol;
                _zGroup deleteGroupWhenEmpty true;
            }
        } forEach _zHouses;

        missionNamespace setVariable [_zombiesVar,"true"];
        hint format ["Zombies spawned at location %1!", _locationName]; sleep 1;
    };
//    if ( _locationZombiesSpawned != "true" && _unitsInLocation != "true") then
//    {

//    };
 }forEach _allLocations;
};