private["_pName","_pUID","_pReason"];
_pName = [_this,0,"",[""]] call BIS_fnc_param;
_pUID = [_this,1,"",[""]] call BIS_fnc_param;
_pReason = [_this,2,"",[""]] call BIS_fnc_param;

if(_pName == "" OR _pUID == "" OR _pReason == "") exitWith {};

diag_log format["||SPY-GLASS|| Nom: %1 | UID: %2 | Raison: %3",_pName,_pUID,_pReason];