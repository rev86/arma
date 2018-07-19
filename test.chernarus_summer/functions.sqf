fncGetClosest = {

    params ["_object","_name",["_debug","false"]];

    _result = [];

    _closestObject = (nearestLocations [position _object,[_name],5000]) select 0;
    _townName = text _closestObject;
    _townPos = position _closestObject;
    _result = [_townPos,_townName];

    if (_debug == "true") then {
        deleteMarker format ["%1", _townName];
        _m2 = createMarker[format ["%1", _townName], _townPos ];
        _m2 setMarkerShape "ICON";
        _m2 setMarkerColor "Default";
        _m2 setMarkerType "flag_NATO";
        _m2 setMarkerText format ["Seize: %1", _name];
        hint _townName;
    };

    _result;
};

fncGetAll = {

    params ["_object","_count","_distance",["_debug","false"]];

    _results = [];
    _townNames = [];
    _townPos = [];
    _allLocationTypes = ["NameVillage","NameCity"];
    _i = 0;

    _closestObjects = (nearestLocations [position _object,_allLocationTypes,_distance]);
    {
        if (_i == _count) exitWith{};
        _townName =  (text _x);
        _townPos = (position _x);
        _results pushBack [_townPos,_townName];

        if (_debug == "true") then {
                deleteMarker format ["%1", _townName];
                _m3 = createMarker[format ["%1", _townName], _townPos];
                _m3 setMarkerShape "ICON";
                _m3 setMarkerColor "Default";
                _m3 setMarkerType "flag_NATO";
                _m3 setMarkerText format ["Seize: %1", _allLocationTypes select _i];
        };
        _i = _i + 1;
    } forEach _closestObjects;

    _results;
};

fncGetWeaponType = {
   params ["_itemString"];

   private ["_retValue", "_type"];

   _retValue = "NO_WEAPON";

   if(isClass( configFile >> "CfgWeapons" >> _itemString )) then {
       _type = getNumber( configFile >> "CfgWeapons" >> _itemString >> "type" );
       //diag_log format ["template type: %1", _type];
       switch _type do {
           case 1: { _retValue = "PRIMARY"; };
           case 4: { _retValue = "SECONDARY"; };
           case 2: { _retValue = "HANDGUN"; };
       };
   };
   _retValue
};

fncHasWeaponClass = {
    params ["_unit","_weapon"];
    private ["_retValue"];

    _retValue = "false";

    _weaponType = _weapon call fncGetWeaponType;

    switch _weaponType do {
       case "PRIMARY": {if(count primaryWeapon _unit > 0) then {_retValue = "true";};};
       case "SECONDARY": {if(count secondaryWeapon _unit > 0) then {_retValue = "true";};};
       case "HANDGUN": {if(count handgunWeapon _unit > 0) then {_retValue = "true";};};
    };

    _retValue;
};

KK_fnc_inHouse = {
	lineIntersectsSurfaces [
		_this,
		_this vectorAdd [0, 0, 50],
		objNull, objNull, true, 1, "GEOM", "NONE"
	] select 0 params ["","","","_house"];
	if (isNil "_house") exitWith {false};
	if (_house isKindOf "house") exitWith {true};
	false
};

fncBuildingHasDoors = {
  params ["_building"];
  private ["_numDoors"];
  private _isEnterable = false;

  _numDoors = getNumber (configFile >> "CFGVehicles" >> typeOf _building >> "numberOfDoors");

  if (_numDoors != 0) then {

      //_door_pos = _nBuilding selectionPosition (format ["Door_%1_trigger", _numDoors]);
      _isEnterable = true;
  };

  _isEnterable;
};

MGI_fnc_setPosAGLS = {
  params ["_obj", "_pos"];
  _wh_pos = getPosASL _obj;

  _pos set [2, (ATLtoASL _pos select 2)-10];
_ins = lineIntersectsSurfaces [_wh_pos, _pos,_obj,objNull, true,1,"VIEW","FIRE"];
_surface_distance = if (count _ins > 0) then [{(_ins select 0 select 0) distance _wh_pos},{0}];
_wh_pos set [2, (getPosASL _obj select 2) - (_surface_distance)];
//_obj setPosASL _wh_pos;
};