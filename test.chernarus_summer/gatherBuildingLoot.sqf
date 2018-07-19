private _bot = _this select 0;
private _buildingPositions = _this select 1;

private _itemBox = [];

_itemsInHolder = [];
_magazinesInHolder = [];
_weaponsInHolder = [];
_backpackInHolder = [];
_weaponsToAdd = [];
_itemsToAdd = [];
_magazinesToAdd = [];
_backpacksToAdd = [];
_nearbyLootHolders = [];

//_nearbyLootHolders = nearestObjects[_bot,["weaponholder"],_radius];

{
   _lootHolder = nearestObject[_x,"weaponholder"];
   if (! isNull _lootHolder ) then {
      _nearbyLootHolders pushBack _lootHolder;
   };
}forEach _buildingPositions;

hint format ["Starting loot gather.Found %1 loot spawn poins", count _nearbyLootHolders];

{
   sleep 1;

  // while {_bot distance2D position _x > 1} do
  // {
      _bot doMove (position _x);
      hint format ["retrying move to position%1...N %2", position _x, random 1000];
      sleep 1;
  // };
  _bot disableAI "ANIM";
  _bot disableAI "AUTOTARGET";
  _bot setCombatMode "Blue";
  _bot switchMove "AinvPknlMstpSnonWnonDnon_G01";

 sleep (3 + floor (random (10)));

 _itemsInHolder = itemCargo _x;
 if (alive _bot && (count _itemsInHolder != 0)) then
 {
    hint format["Found items:%1", str(_itemsInHolder)];
    //sleep 3;
    {
       if(!(_x in items _bot)) then
       {
         if (_x find "V_" == 0) then {_bot addVest _x;};
         if (_x find "H_" == 0) then {_bot addHeadgear _x;};
         if (_x find "U_" == 0) then {_bot addUniform _x;}
         else {_bot addItem _x;};
       }
       else
       {
         _itemsToAdd pushBack _x;
       };
    }forEach _itemsInHolder;
    clearItemCargo _x;
    sleep 1;
 };

  _weaponsInHolder = weaponCargo _x;
  if (alive _bot && (count _weaponsInHolder != 0)) then
  {
      hint format["Found weapons:%1", str(_weaponsInHolder)];
      //sleep 3;
      {
         if (!(_x in weapons _bot) || (([_bot,_x] call fncHasWeaponClass == "true") && (50 < random 100))) then
         {
              hint "I wil take this weapon";
              //sleep 1;
              _weaponType = _x call fncGetWeaponType;
              switch (_weaponType) do {
                 case "PRIMARY":   {_weaponsToAdd pushBack primaryWeapon _bot;sleep 1;};
                 case "SECONDARY": {_weaponsToAdd pushBack secondaryWeapon _bot;sleep 1;};
                 case "HANDGUN":   {_weaponsToAdd pushBack handgunWeapon _bot;sleep 1;};
                 default { hint "no weapon";};
              };
              _bot addWeapon _x;
         }
         else
          {
             hint "I don't need this weapon";
             _weaponsToAdd pushBack _x;
             //sleep 1;
          };
         hint format["_weaponsToAdd=%1", str _weaponsToAdd]; sleep 2;
      }forEach _weaponsInHolder;
      clearWeaponCargo _x;
      sleep 1;
  };

 _magazinesInHolder = magazineCargo _x;
  if (alive _bot && (count _magazinesInHolder != 0)) then
  {

    hint format["Found magazines:%1", str(_magazinesInHolder)];
    //sleep 3;
    {
       _bot addMagazine _x;
    }forEach _magazinesInHolder;
    clearMagazineCargo _x;
    sleep 1;
  };

 _backpackInHolder = backpackCargo _x;
 if (alive _bot && (count _backpackInHolder != 0)) then
 {
    _backpack = _backpackInHolder select 0;
    _backpackItems = backpackItems _bot;
    if (_backpack != backpack _bot) then
    {
        hint format["Found backpack:%1", str(_backpackInHolder)];
        clearAllItemsFromBackpack _bot;
        _bot addBackpack (_backpack);
        {_bot addItemToBackpack _x;} forEach _backpackItems;
        clearBackpackCargoGlobal _x;
        sleep 1;
    };
 };

 if (alive _bot) then
 {
    _bot enableAI "ANIM";
    _bot switchMove "";
    _itemBox = "GroundWeaponHolder" createVehicle [0,0,0];
    _itemBox setPos (position _x);
    {_itemBox addWeaponCargoGlobal [_x,1]; sleep 1;} forEach _weaponsToAdd;
    {_itemBox addItemCargoGlobal [_x,1]; sleep 1;} forEach _itemsToAdd;
    {_itemBox addMagazineCargoGlobal [_x,1]; sleep 1;} forEach _magazinesToAdd;
    _weaponsToAdd = [];
    _itemsToAdd = [];
    _magazinesToAdd = [];
    _backpacksToAdd = [];
    //deleteVehicle _x;
 };

}forEach _nearbyLootHolders;



/*
hint str(typeof _backpack);
hint str(typeof (_list select 0));
deleteVehicle (_list select 0);


(weaponCargo(nearestObjects[p1,["weaponholder"],20] select 0));
AinvPknlMstpSnonWnonDnon_G01

*/