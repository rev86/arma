private _unit = _this select 0;

_unitPos = _unit getVariable "startPosition";
_grp = createGroup side group _unit;
_newUnit = _grp createUnit [typeOf _unit, _unitPos, [], 0, "NONE"];
_newUnit setName "respawned_" + (name _unit);

removeAllWeapons _newUnit;
removeAllItems _newUnit;
removeAllAssignedItems _newUnit;
removeVest _newUnit;
removeBackpack _newUnit;
removeHeadgear _newUnit;
removeGoggles _newUnit;

[_newUnit] execVM "stalk.sqf";

hint format ["Unit %1 respawned", name _unit];