private _bot = _this select 0;
private _buildingPositions = _this select 1;

private _itemBox = [];

private _itemsInHolder = [];
private _magazinesInHolder = [];
private _weaponsInHolder = [];
private _backpackInHolder = [];
private _weaponsToAdd = [];
private _itemsToAdd = [];
private _magazinesToAdd = [];
private _backpacksToAdd = [];

_itemsInHolder = [];
_magazinesInHolder = [];
_weaponsInHolder = [];
_backpackInHolder = [];
_weaponsToAdd = [];
_itemsToAdd = [];
_magazinesToAdd = [];
_backpacksToAdd = [];
_nearbyLootHolders = [];
//looting timeout is 5 min
_lootingTimeout = diag_tickTime + (5*60);
_lootHolderContents = [];

/*
TODO: grab only weapons magazines that are needed, dont change weapon if there's no spawned magazines around
dont loot empty lootholders!
run away from zombies if has no weapon
*/

{
   _lootHolder = nearestObject[_x,"weaponholder"];
   if (! isNull _lootHolder) then {
      _nearbyLootHolders pushBack _lootHolder;
   };
}forEach _buildingPositions;

//randomize order of looting for each bot
_nearbyLootHolders = _nearbyLootHolders call BIS_fnc_arrayShuffle;

//hint format ["Starting loot gather.Found %1 loot spawn poins", count _nearbyLootHolders];

{
 sleep 1;
 _pos = position _x;
 //loot only if no zombies close
 _nearEntities = _pos nearEntities 10;
 _nearZombies = _nearEntities select {faction _x == "Ryanzombiesfaction"};
 waitUntil{count _nearZombies == 0};
 if ((_pos select 0) + (_pos select 1) + (_pos select 2) != 0) then
 {
 _bot doMove (_pos);
 _bot setVariable["destination", _pos];
  //hint format ["Moving to position %1", _pos];

  waitUntil{_bot distance2D _pos < 2};
 // _lootHolderContents = weaponsItemsCargo _x;
 // if (count _lootHolderContents != 0) then
 // {
      sleep 1;
      _bot disableAI "ANIM";
      //_bot disableAI "AUTOTARGET";
      //_bot setCombatMode "YELLOW";
      _bot switchMove "AinvPknlMstpSnonWnonDnon_G01";

      sleep (3 + floor (random (7)));

      _itemsInHolder = itemCargo _x;
      if (alive _bot && (count _itemsInHolder != 0)) then
      {
         //hint format["Found items:%1", str(_itemsInHolder)];
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
      };

       _weaponsInHolder = weaponCargo _x;
       if (alive _bot && (count _weaponsInHolder != 0)) then
       {
           //hint format["Found weapons:%1", str(_weaponsInHolder)];
           //sleep 3;
           {
              if (!(_x in weapons _bot) || (([_bot,_x] call fncHasWeaponClass == "true") && (50 < random 100))) then
              {
                 //if (([_bot,_x] call fncHasWeaponClass == "false") || (([_bot,_x] call fncHasWeaponClass == "true") && (1==1))) then
                 //{
                   //hint "I wil take this weapon";
                   //sleep 1;
                   _weaponType = _x call fncGetWeaponType;
                   switch (_weaponType) do {
                      case "PRIMARY":   {_weaponsToAdd pushBack primaryWeapon _bot;sleep 1;};
                      case "SECONDARY": {_weaponsToAdd pushBack secondaryWeapon _bot;sleep 1;};
                      case "HANDGUN":   {_weaponsToAdd pushBack handgunWeapon _bot;sleep 1;};
                      default { hint "no weapon";};
                   };
                   _bot addWeapon _x;
                // };
              }
              else
               {
                  hint "I don't need this weapon";
                  _weaponsToAdd pushBack _x;
                  //sleep 1;
               };
              //hint format["_weaponsToAdd=%1", str _weaponsToAdd]; sleep 2;
           }forEach _weaponsInHolder;
           clearWeaponCargo _x;
           //sleep 1;
       };

      _magazinesInHolder = magazineCargo _x;
       if (alive _bot && (count _magazinesInHolder != 0)) then
       {

         //hint format["Found magazines:%1", str(_magazinesInHolder)];
         //sleep 3;
         {
            _bot addMagazine _x;
         }forEach _magazinesInHolder;
         clearMagazineCargo _x;
       };

      _backpackInHolder = backpackCargo _x;
      if (alive _bot && (count _backpackInHolder != 0)) then
      {
         _backpack = _backpackInHolder select 0;
         _backpackItems = backpackItems _bot;
         if (! isNil "_backpack" && _backpack != backpack _bot) then
         {
             //hint format["Found backpack:%1", str(_backpackInHolder)];
             clearAllItemsFromBackpack _bot;
             _bot addBackpack (_backpack);
             {_bot addItemToBackpack _x;} forEach _backpackItems;
             clearBackpackCargoGlobal _x;
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
//    };
  };
 };

if (diag_tickTime > _lootingTimeout) exitWith{0};

}forEach _nearbyLootHolders;