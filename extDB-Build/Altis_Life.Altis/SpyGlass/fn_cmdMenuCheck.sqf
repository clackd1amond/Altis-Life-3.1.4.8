private["_validMenus","_lastMenu"];
_validMenus = 
[
	"RscMainMenu","RscMoveHigh","#WATCH","#WATCH0","RscWatchDir","RscWatchMoveDir","#GETIN","#RscStatus","RscCallSupport","#ACTION","RscRadio","RscMenuReply","","#User:BIS_fnc_addCommMenuItem_menu",
	"RscCombatMode","RscFormations","RscTeam","RscSelectTeam","RscReply","#User:BIS_Menu_GroupCommunication","#CUSTOM_RADIO","RscGroupRootMenu","RscMenuStatus","RscMenuMove","RscMenuFormations"
];

_lastMenu = "";
while {true} do
{
	waitUntil {commandingMenu != _lastMenu};
	_lastMenu = commandingMenu;

	if(!(commandingMenu in _validMenus)) then 
	{
		[[profileName,getPlayerUID player,_lastMenu],"SPY_fnc_observe",false,false] call life_fnc_MP;
		[[[0,1],format["%1 was observed by SPY-GLASS, he/she was trying to access commanding menu:\n\n %2\n\n and that commanding-menu is not known to the system. PLEASE NOTE he/she may not be cheating but the SPY-GLASS found it relavent to report in",profileName,
		_lastMenu]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;
		showCommandingMenu "";
	};
};