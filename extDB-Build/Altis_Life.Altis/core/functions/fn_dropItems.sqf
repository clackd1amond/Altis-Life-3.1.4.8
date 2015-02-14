/*
	File: fn_dropItems.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Called on death, player drops any 'virtual' items they may be carrying.
*/
private["_obj","_unit","_item","_value","_data","_data2","_death","_total","_weight","_exit","_ind"];
_unit = _this select 0;
_death = _this select 1;
_data = "";
_value = "";
_exit = false;
if (_death) then 
{
	_data2 = life_inv_items + ["life_cash"];
} else {
	_data = lbData[2005,(lbCurSel 2005)];
	if (_data == "") exitWith
	{
		hint "Vous devez choisir un objet.";
		_exit = true;
	};
	_data2 = [_data,0] call life_fnc_varHandle;
	_data2 = [_data2];
	if(life_is_processing) exitWith 
	{
		hint "Vous êtes en train de process petit malin.";
		_exit = true;
	};

	if(player != vehicle player) exitWith 
	{
		titleText["Vous ne pouvez pas jeter un objet lorsque vous êtes dans un véhicule.","PLAIN"];
		_exit = true;
	};

	if(side player != west) then 
	{
		_ind = [_data,life_illegal_items] call TON_fnc_index;
		if(_ind != -1 && ([west,getPos player,100] call life_fnc_nearUnits)) exitWith {titleText["C'est un objet illégal et les flics sont à proximité, vous ne pouvez jetez pas cette preuve","PLAIN"];_exit = true;};
	};
};

if(_exit) exitWith {};
if (count _data2 < 1) exitWith {};
if((time - life_action_delay) < 1 && !(_death)) exitWith {hint "Vous ne pouvez pas lacher des objets aussi rapidement. Essayez de les lacher par paquet!"};
life_action_delay = time;

{
	_item = _x;
	_var = [_item,1] call life_fnc_varHandle;
	_total = missionNamespace getVariable _item;
	if (_death) then 
	{
		_value = missionNamespace getVariable _item;
		if(_item!="life_cash") then 
		{
			[false,_var,_value] call life_fnc_handleInv;
		};
	} else {
		_value = ctrlText 2010;
		if(parseNumber(_value) <= 0) exitWith 
		{
			hint "Vous avez besoin de rentrer le montant que vous voulez lacher.";
			_exit = true;
		};

		if(!([false,_var,(parseNumber _value)] call life_fnc_handleInv)) exitWith 
		{
			hint "Vous ne pouvez pas lacher autant d'objet, peut-être que vous n'en avez pas assez?";
			_exit = true;
		};
		_value = (parseNumber _value);
	};

	if(_exit) exitWith {};
	_weight = ([_var] call life_fnc_itemWeight) * _value;

	switch(_item) do
	{
		case "life_inv_water":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_BottlePlastic_V1_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_inv_tbacon":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_TacticalBacon_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_inv_redgull":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_Can_V3_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_inv_fuelE":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_CanisterFuel_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_inv_fuelF":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_CanisterFuel_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_inv_coffee":
		{
			if (_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_Can_V3_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};

		case "life_cash":
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_Money_F" createVehicle _pos;
				_obj setVariable["item",["money",_value],true];
				_obj setPos _pos;
				["cash","set",(_total - _value)] call life_fnc_updateCash;
			};
		};

		default
		{
			if(_value > 0) then
			{
				_pos = _unit modelToWorld [0,3,0];
				_pos = [_pos select 0, _pos select 1, 0];
				_obj = "Land_Suitcase_F" createVehicle _pos;
				_obj setPos _pos;
				_obj setVariable["item",[_var,_value],true];
			};
		};
	};
	if (_value > 0) then {_obj setVariable["idleTime",time,true];};
} foreach (_data2);

[] call life_fnc_p_updateMenu;