_position = _this select 0;
_radius  = _this select 1;

_weaponArray = [
	"srifle_DMR_05_blk_F",
	"arifle_Katiba_F",
	"srifle_DMR_06_olive_F",
	"arifle_Mk20_F",
	"arifle_MX_SW_F",
	"hgun_PDW2000_F",
	"LMG_Zafir_F",
	"arifle_MXC_khk_F",
	"hgun_P07_khk_F",
	"launch_RPG7_F",
	"arifle_AKS_F",
	"hgun_Pistol_01_F"
];

_itemsArray = [
    "Laserdesignator_03",
    "ItemMap",
    "ItemCompass",
    "ItemRadio",
    "NVGoggles_OPFOR",
    "muzzle_snds_H_snd_F",
    "optic_DMS"
];

_backpacksAray = [
    "B_AssaultPack_dgtl",
    "B_Respawn_Sleeping_bag_brown_F",
    "B_FieldPack_cbr",
    "B_LegStrapBag_coyote_F",
    "B_TacticalPack_ocamo"
];

_itemBoxArray = [];
_enterableHouseArray = [];

_houseArray = _position nearObjects ["house",_radius];

{
  if ([_x] call fncBuildingHasDoors ) then {_enterableHouseArray pushBack _x;};
}forEach _houseArray;

{
	_buildingPositions = [_x] call BIS_fnc_buildingPositions;
	{
		_weapon = _weaponArray select (floor (random (count _weaponArray)));
		_itemBox = "GroundWeaponHolder" createVehicle [0,0,0];
		_lootInItemBox = "false";

		//[_itemBox,_x] call MGI_fnc_setPosAGLS;

		_itemBox setPos _x;
        if (10 > random 100) then {
            _itemBox addWeaponCargoGlobal [_weapon,1];
            _lootInItemBox = "true";
        };
		_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
		_mag = _magazines select (floor (random (count _magazines)));
        if (30 > random 100) then {
		    _itemBox addMagazineCargoGlobal [_mag,2];
		    _lootInItemBox = "true";
		};
		_item = _itemsArray select (floor (random (count _itemsArray)));
		if (50 > random 100) then {
		    _itembox addItemCargoGlobal [_item,1];
		    _lootInItemBox = "true";
		};
		_backpack = _backpacksAray select (floor (random (count _backpacksAray)));
		if (15 > random 100) then {
            _itembox addBackpackCargoGlobal [_backpack,1];
            _lootInItemBox = "true";
        };
        if (_lootInItemBox != "true" ) then
        {
           deleteVehicle _itemBox;
        };
	} forEach _buildingPositions;
} forEach _enterableHouseArray;

//remove loot
/*
sleep 120;
{
	deleteVehicle _x;
} forEach _itemBoxArray;

_list = nearestObjects[p1,["weaponholder"],20];
_backpack = firstBackpack(_list select 0);
hint str(typeof _backpack);
hint str(typeof (_list select 0));
deleteVehicle (_list select 0);

*/
