//_position = _this select 0;
//_radius  = _this select 1;

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
	"hgun_Pistol_01_F",
	"arifle_AKM_F"
];

_CUPWeaponArray = [
    "CUP_srifle_CZ750",
    "CUP_hgun_Duty",
    "CUP_hgun_Duty_M3X",
    "CUP_srifle_CZ550",
    "CUP_srifle_CZ550_rail",
    "CUP_srifle_LeeEnfield",
    "CUP_srifle_LeeEnfield_rail",
    "CUP_srifle_M24_wdl",
    "CUP_srifle_M24_ghillie",
    "CUP_srifle_M24_des_LeupoldMk4LRT",
    "CUP_hgun_Phantom_Flashlight",
    "CUP_hgun_glock17_flashlight",
    "CUP_hgun_glock17_snds",
    "CUP_hgun_M9",
    "CUP_hgun_M9_snds",
    "CUP_hgun_Makarov",
    "CUP_hgun_MicroUzi",
    "CUP_hgun_MicroUzi_snds",
    "CUP_hgun_PB6P9_snds",
    "CUP_hgun_TaurusTracker455",
    "CUP_sgun_Saiga12K",
    "CUP_srifle_SVD",
    "CUP_srifle_SVD_pso",
    "CUP_srifle_VSSVintorez_pso",
    "CUP_arifle_AK47",
    "CUP_arifle_AK74",
    "CUP_arifle_AK74M",
    "CUP_arifle_AK74M_GL",
    "CUP_arifle_AKS74",
    "CUP_arifle_AKS74U",
    "CUP_arifle_AKM",
    "CUP_arifle_AKS_Gold",
    "CUP_arifle_AK107_kobra",
    "CUP_smg_bizon_snds",
    "CUP_hgun_Colt1911",
    "CUP_hgun_Colt1911_snds",
    "CUP_arifle_CZ805_A1",
    "CUP_arifle_CZ805_A2_Holo_Laser"
];

_CUPMagazinesArray = [
    "CUP_HandGrenade_M67",
    "CUP_HandGrenade_L109A1_HE",
    "CUP_HandGrenade_RGD5",
    "CUP_HandGrenade_RGO",
    "CUP_TimeBomb_M",
    "CUP_PipeBomb_M"
];

_CUPItemsArray = [
    "CUP_optic_PSO_1",
    "CUP_optic_Kobra",
    "CUP_muzzle_PBS4",
    "CUP_optic_SB_3_12x50_PMII",
    "CUP_optic_Leupold_VX3",
    "CUP_optic_Elcan",
    "CUP_Binocular_Vector"
];

_itemsArray = [
    "ItemMap",
    "ItemCompass",
    "ItemRadio",
    "NVGoggles_OPFOR",
    "muzzle_snds_H_snd_F",
    "optic_DMS",
    "H_Watchcap_blk",
    "SmokeShell",
    "H_RacingHelmet_1_blue_F",
    "acc_pointer_IR",
    "acc_flashlight_pistol",
    "MiniGrenade",
    "SmokeShell",
    "H_Hat_camo",
    "HandGrenade"
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

_weaponArray = + _CUPWeaponArray;
_itemsArray = + _CUPItemsArray;
_itemsArray = + _CUPMagazinesArray;

_allLocationTypes = ["NameVillage","NameCity","NameLocal"];
_allLocations = (nearestLocations [position player,_allLocationTypes,10000]);

_radius  = 300;

while {true} do
{
 sleep 10;
 {
    _locationName = text _x;
    _locationPos = position _x;
    _locationLootSpawned = (((missionNamespace getVariable _locationName) select 0) select 1);
    _unitsInLocation = "false";

    {if (_x  distance2D _locationPos < 400) exitWith{_unitsInLocation = "true";}} forEach allUnits;

    if ( _locationLootSpawned != "true" && _unitsInLocation == "true") then
    {
        _houseArray = _locationPos nearObjects ["house",_radius];

        {
          if ([_x] call fncBuildingHasDoors ) then
          {
            _enterableHouseArray pushBack _x;
            _x setVariable ["loot_spawned","false"];
          };
        }forEach _houseArray;

        {
            if ((_x getVariable "loot_spawned") != "true") then
            {
                _buildingPositions = [_x] call BIS_fnc_buildingPositions;
                {
                    _weapon = _weaponArray select (floor (random (count _weaponArray)));
                    _itemBox = "GroundWeaponHolder" createVehicle [0,0,0];
                    _lootInItemBox = "false";

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
                _x setVariable ["loot_spawned", "true"];
            };
        } forEach _enterableHouseArray;

        missionNamespace setVariable [_locationName,[["loot_spawned","true"]]];
        hint format ["Loot spawned at location %1!", _locationName]; sleep 1;
    };
 }forEach _allLocations;
};
//remove loot
/*
sleep 120;
{
	deleteVehicle _x;
} forEach _itemBoxArray;


*/
