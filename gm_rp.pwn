/*

Projekt: eQualityGaming
Wersja: v1.0(d)
Data: 11/01/2020
Autor: Sky

*/

#include <a_samp>
#include <mysql>
#include <streamer>
#include <sscanf2>
#include <timestamp>
#include <md5>
#include <zcmd>

native gpci(playerid, serial[], len);
new FreeID[MAX_PLAYERS];
new Text:LSNews[2], NewsTimer, Text:ForGame, Text:VehicleInfo[MAX_PLAYERS];

#include "modules/Defines.pwn"

#include "modules/vehicle_names.pwn"
#include "modules/vmachines.pwn"

#include "modules/Enums/char_enums.pwn"
#include "modules/Enums/item_enums.pwn"
#include "modules/Enums/vehicle_enums.pwn"
#include "modules/Enums/object_enums.pwn"
#include "modules/Enums/zone_enums.pwn"
#include "modules/Enums/door_enums.pwn"

#include "modules/Functions/SetPlayerHealthEx.pwn"
#include "modules/Functions/GivePlayerHealth.pwn"
#include "modules/Functions/Log.pwn"
#include "modules/Functions/GetDistance.pwn"

#include "modules/Stocks/HashPassword.pwn"
#include "modules/Stocks/PlayerToPlayer.pwn"
#include "modules/Stocks/LoadDoors.pwn"
#include "modules/Stocks/UnloadDoors.pwn"
#include "modules/Stocks/GetNearestDoors.pwn"
#include "modules/Stocks/RemoveVendingMachines.pwn"
#include "modules/Stocks/IsNumeric.pwn"
#include "modules/Stocks/LoadZones.pwn"
#include "modules/Stocks/UnloadZones.pwn"
#include "modules/Stocks/GetPlayerZone.pwn"
#include "modules/Stocks/IsPlayerInArea.pwn"
#include "modules/Stocks/CheckCharacters.pwn"
#include "modules/Stocks/WordWrap.pwn"
#include "modules/Stocks/EscapePL.pwn"
#include "modules/Stocks/GetPlayerSpeed.pwn"
#include "modules/Stocks/UpdateNick.pwn"
#include "modules/Stocks/TeamMessage.pwn"
#include "modules/Stocks/AdminMessage.pwn"
#include "modules/Stocks/GetPlayerID.pwn"
#include "modules/Stocks/TryLogin.pwn"
#include "modules/Stocks/InfoVehicle.pwn"
#include "modules/Stocks/InfoTD.pwn"
#include "modules/Stocks/ClearPlayerData.pwn"
#include "modules/Stocks/Tip.pwn"
#include "modules/Stocks/Strreplace.pwn"
#include "modules/Stocks/PlayerName.pwn"
#include "modules/Stocks/GetNextPlayerID.pwn"
#include "modules/Stocks/GetPreviousPlayerID.pwn"
#include "modules/Stocks/GetLowestID.pwn"
#include "modules/Stocks/SaveVehicle.pwn"
#include "modules/Stocks/SaveObject.pwn"
#include "modules/Stocks/SaveItem.pwn"
#include "modules/Stocks/SaveCharacter.pwn"
#include "modules/Stocks/ShowLoginDialog.pwn"
#include "modules/Stocks/SendClientMessageEx.pwn"
#include "modules/Stocks/SendWrappedMessageToPlayerRange.pwn"
#include "modules/Stocks/ReplaceEmoticionsToText.pwn"
#include "modules/Stocks/LoadObjects.pwn"
#include "modules/Stocks/LoadItems.pwn"
#include "modules/Stocks/GetFreeObjectID.pwn"
#include "modules/Stocks/GetFreeItemID.pwn"
#include "modules/Stocks/GetFreeVehicleID.pwn"
#include "modules/Stocks/UseItem.pwn"
#include "modules/Stocks/GetWeaponSlot.pwn"
#include "modules/Stocks/LoadVehicles.pwn"
#include "modules/Stocks/GetObjectUID.pwn"
#include "modules/Stocks/GetVehicleUID.pwn"
#include "modules/Stocks/IsVehicleOccupied.pwn"
#include "modules/Stocks/GetVehicleName.pwn"

#include "modules/Commands.pwn"
#include "modules/SecTimer.pwn"
#include "modules/UnfreezePlayer.pwn"
#include "modules/EngineStart.pwn"

main()
{
	printf("\n# Projekt eQualityGaming RolePlay za³adowano. #\n");
}

public OnGameModeInit()
{
	#if DEBUG_MODE == 1

    mysql_connect(SQL_HOST2, SQL_USER2, SQL_DB2, SQL_PASS2);

	if(mysql_ping() == 1)
	{
	    print("Polaczono z baza danych.");
	}
	else
	{
		print("Nie mozna polaczyc sie z baza danych, zamykam serwer.");

		SendRconCommand("exit");
		return 1;
	}

	mysql_debug(1);

	#else

	mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);

	mysql_connect(SQL_HOST2, SQL_USER2, SQL_DB2, SQL_PASS2);

	if(mysql_ping() == 1)
	{
	    print("Polaczono z baza danych.");
	}
	else
	{
		print("Nie mozna polaczyc sie z baza danych, zamykam serwer.");

		SendRconCommand("exit");
		return 1;
	}

	#endif

	mysql_query("UPDATE `rp_chars` SET `char_ingame` = 0");

	SetTimer("SecTimer", 1000, true);

	SetGameModeText("eQuality Gaming v0.1 - DEV");

	AllowInteriorWeapons(false);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ShowPlayerMarkers(false);
	ShowNameTags(false);
	SetNameTagDrawDistance(0.0);
	LimitGlobalChatRadius(1.0);
	ManualVehicleEngineAndLights();

	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    PlayerData[i][char_name_tag]	= CreateDynamic3DTextLabel(" ", 0xFFFFFF80, 0.0, 0.0, 0.2, 20.0, i, INVALID_VEHICLE_ID, 1);
	    PlayerData[i][char_desc_text]	= CreateDynamic3DTextLabel(" ", 0xC2A2DAFF, 0.0, 0.0, -0.6, 20.0, i, INVALID_VEHICLE_ID, 1);

		PlayerData[i][char_info] = TextDrawCreate(512.000000, 280.000000, "~w~Nie mozesz skorzystac z takiej komendy. Uzyj ~y~/pomoc~w~, jezeli szukasz pomocy.");
		TextDrawAlignment(PlayerData[i][char_info], 2);
		TextDrawBackgroundColor(PlayerData[i][char_info], 96);
		TextDrawFont(PlayerData[i][char_info], 1);
		TextDrawLetterSize(PlayerData[i][char_info], 0.329998, 1.299999);
		TextDrawColor(PlayerData[i][char_info], -1);
		TextDrawSetOutline(PlayerData[i][char_info], 1);
		TextDrawSetProportional(PlayerData[i][char_info], 1);
		TextDrawUseBox(PlayerData[i][char_info], 1);
		TextDrawBoxColor(PlayerData[i][char_info], 128);
		TextDrawTextSize(PlayerData[i][char_info], 593.000000, 190.000000);
		TextDrawTextSize(PlayerData[i][char_info], 593.000000, 190.000000);

		VehicleInfo[i] = TextDrawCreate(323.000000, 360.000000, "~y~Marka: ~w~Sultan ~y~UID: ~w~12 ~y~Owner: ~w~1 ~y~Kolor: ~w~1:1 ~y~Model: ~w~560~n~~y~Pozycja X: ~w~0.0 ~y~Pozycja Y: ~w~0.0 ~y~Pozycja Z: ~w~0.0~n~~p~Paliwo: ~w~100.0 ~p~Przebieg: ~w~5.0 ~p~HP: ~w~1000.0");
		TextDrawAlignment(VehicleInfo[i], 2);
		TextDrawBackgroundColor(VehicleInfo[i], 96);
		TextDrawFont(VehicleInfo[i], 1);
		TextDrawLetterSize(VehicleInfo[i], 0.300000, 1.100000);
		TextDrawColor(VehicleInfo[i], -1);
		TextDrawSetOutline(VehicleInfo[i], 1);
		TextDrawSetProportional(VehicleInfo[i], 1);
		TextDrawSetProportional(VehicleInfo[i], 1);
	}

	LSNews[0] = TextDrawCreate(-10.000000, 431.000000, "_");
	TextDrawBackgroundColor(LSNews[0], 255);
	TextDrawFont(LSNews[0], 1);
	TextDrawLetterSize(LSNews[0], 0.500000, 2.000000);
	TextDrawColor(LSNews[0], -1);
	TextDrawSetOutline(LSNews[0], 0);
	TextDrawSetProportional(LSNews[0], 1);
	TextDrawSetShadow(LSNews[0], 1);
	TextDrawUseBox(LSNews[0], 1);
	TextDrawBoxColor(LSNews[0], 144);
	TextDrawTextSize(LSNews[0], 650.000000, 0.000000);
	TextDrawTextSize(LSNews[0], 650.000000, 0.000000);

	LSNews[1] = TextDrawCreate(7.000000, 433.000000, "~r~~h~LS News: ~w~W tej chwili nikt nie nadaje.");
	TextDrawBackgroundColor(LSNews[1], 128);
	TextDrawFont(LSNews[1], 1);
	TextDrawLetterSize(LSNews[1], 0.209999, 1.000000);
	TextDrawColor(LSNews[1], -1);
	TextDrawSetOutline(LSNews[1], 1);
	TextDrawSetProportional(LSNews[1], 1);
	TextDrawSetProportional(LSNews[1], 1);

	ForGame = TextDrawCreate(580.000000, 396.000000, "~r~~h~F~w~or~r~~h~G~w~ame~n~22/22/3030");
	TextDrawAlignment(ForGame, 2);
	TextDrawBackgroundColor(ForGame, 128);
	TextDrawFont(ForGame, 1);
	TextDrawLetterSize(ForGame, 0.330000, 1.100000);
	TextDrawColor(ForGame, -1);
	TextDrawSetOutline(ForGame, 1);
	TextDrawSetProportional(ForGame, 1);
	TextDrawSetProportional(ForGame, 1);

	LoadItems();
	LoadVehicles();
	LoadObjects();
	LoadObjectMmat();
	LoadZones();
	LoadDoors();
	return 1;
}

public OnGameModeExit()
{
    UnloadZones();
	UnloadDoors();
	return 1;
}

public OnPlayerConnect(playerid)
{
	for(new i=0; i<255; i++)
	    SendClientMessage(playerid, -1, " ");

    new hour, minute, second;
	gettime(hour, minute, second);
	SetPlayerTime(playerid, hour, minute);

	TryLogin(playerid);

	TextDrawShowForPlayer(playerid, LSNews[0]);
	TextDrawShowForPlayer(playerid, LSNews[1]);
	TextDrawShowForPlayer(playerid, ForGame);

	RemoveBuildingForPlayer(playerid, 6067, 1296.8281, -1427.5078, 19.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 6068, 1247.9141, -1429.9688, 15.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1256.9844, -1443.0313, 12.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 6052, 1247.9141, -1429.9688, 15.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 6053, 1296.8281, -1427.5078, 19.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1312, 1343.8594, -1426.0156, 16.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1328.0859, -1419.7578, 12.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1329.9219, -1418.5156, 13.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1256.9844, -1417.7031, 12.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 1289.7266, -1415.0781, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 1332.0781, -1415.0781, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1312, 1307.6172, -1394.4766, 16.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1249.9844, -1481.4609, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1258.1797, -1478.0000, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1250.6563, -1466.0000, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1260.1797, -1454.1016, 9.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 5931, 1114.3125, -1348.1016, 17.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 1085.7031, -1361.0234, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, 1015.5313, -1337.1719, 12.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 1112.6172, -1389.8672, 15.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 5810, 1114.3125, -1348.1016, 17.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 5993, 1110.8984, -1328.8125, 13.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 5811, 1131.1953, -1380.4219, 17.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 1141.9844, -1346.1094, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5929, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1341.8516, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1328.0938, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1356.2109, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1068.1172, -1275.0938, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1184.7891, -1406.9063, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1140.8984, -1280.1172, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1161.5859, -1281.3594, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1182.6484, -1280.0781, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1150.5078, -1269.9375, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1190.3047, -1389.8047, 15.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1194.3203, -1415.2891, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.5625, -1394.7109, 15.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1244.0391, -1406.5313, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1194.7969, -1290.8516, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.3203, -1281.4141, 15.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1216.8516, -1270.7656, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5812, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1245.7266, -1281.3359, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1250.4531, -1389.7500, 15.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1270.8516, -1394.6797, 15.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1261.3594, -1291.1797, 15.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1269.5469, -1280.3203, 15.7109, 0.25);

	SetPlayerColor(playerid, 0x000000FF);

	if(PlayerData[playerid][char_admin_level] > 6)
	{
		UpdateNick(playerid);
    	//Attach3DTextLabelToPlayer(PlayerData[playerid][char_name_tag], playerid, 0.0, 0.0, 0.15);
	}
	else
	{
	    UpdateNick(playerid);
    	//Attach3DTextLabelToPlayer(PlayerData[playerid][char_name_tag], playerid, 0.0, 0.0, 0.15);
	}

	RemoveVendingMachines(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerData[playerid][char_logged])
	{
		SaveCharacter(playerid);
		SaveItem(playerid);
	}

	TextDrawHideForPlayer(playerid, LSNews[0]);
	TextDrawHideForPlayer(playerid, LSNews[1]);
	TextDrawHideForPlayer(playerid, ForGame);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(PlayerData[playerid][char_last_pos][0] > 0.0)
	{
	    SetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
	    SetPlayerFacingAngle(playerid, PlayerData[playerid][char_last_pos][3]);
	    SetCameraBehindPlayer(playerid);
	}
	else
	{
		SetPlayerPos(playerid, 838.2526,-1346.3013,7.1787);
		SetPlayerFacingAngle(playerid, 321.9926);
		SetCameraBehindPlayer(playerid);
	}

	SetPlayerHealthEx(playerid, PlayerData[playerid][char_health]);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	for(new i=0; i<GetMaxPlayers(); i++)
	    if(IsPlayerConnected(i))
	        if(PlayerData[i][char_spectate_id] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	            PlayerSpectateVehicle(i, vehicleid);

    if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 7 && !ispassenger)
    {
    	new uid = GetVehicleUID(vehicleid);
    	new Float:X, Float:Y, Float:Z;
    	GetPlayerPos(playerid, X, Y, Z);
		if(Vehicle[uid][veh_owner] != PlayerData[playerid][char_uid])
		{
			Tip(playerid, "To nie jest Twój pojazd.");
 			SetPlayerPos(playerid, X, Y, Z);
		}

		if(PlayerData[playerid][char_bw] != 0)
		{
			SetPlayerPos(playerid, X, Y, Z);
			return 1;
		}

		if(Vehicle[uid][veh_locked])
		{
			GameTextForPlayer(playerid, "~r~POJAZD ZAMKNIETY!", 3000, 4);
			SetPlayerPos(playerid, X, Y, Z);
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    for(new i=0; i<GetMaxPlayers(); i++)
	    if(IsPlayerConnected(i))
	        if(PlayerData[i][char_spectate_id] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	            PlayerSpectatePlayer(i, playerid);

	new uid = GetVehicleUID(vehicleid);
	SaveVehicle(uid);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	switch(weaponid)
	{
	    case 0..1:
		{
			new Float:ilosc = PlayerData[playerid][char_strength] * 0.0002;

            PlayerData[damagedid][char_last_damaged_weapon] = 0;

			GivePlayerHealth(damagedid, -ilosc);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], ilosc, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 24:
		{
			PlayerData[damagedid][char_last_damaged_weapon] = 24;
			GivePlayerHealth(damagedid, -25.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 25.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 31:
		{
			PlayerData[damagedid][char_last_damaged_weapon] = 31;
			GivePlayerHealth(damagedid, -5.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 5.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	    case 38:
		{
		    PlayerData[damagedid][char_last_damaged_weapon] = 38;
			GivePlayerHealth(damagedid, -50.0);

			new str[128];
			format(str, sizeof(str), "%s gives damage to %s for %.1f (weapon: %d, ping: %d) HP: %.1f", PlayerData[playerid][char_name], PlayerData[damagedid][char_name], 50.0, weaponid, GetPlayerPing(playerid), PlayerData[damagedid][char_health]);
			Log("dmg", str);
		}
	}

	switch(bodypart)
	{
	    case 0..2: { }
	    case 3: //Torso
	    {
	        //kod
	    }
	    case 4: //Groin
		{
		    //kod
		}
		case 5..6: //Left arm, right arm
		{
		    PlayerData[damagedid][char_body_part_damaged][2] = 30;
		    PlayerData[damagedid][char_body_part_damaged][3] = 30;
		}
		case 7..8: //Left leg, right leg
		{
		    PlayerData[damagedid][char_body_part_damaged][4] = 30;
			PlayerData[damagedid][char_body_part_damaged][5] = 30;
		}
		case 9: //Head
		{
		    //kod
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(issuerid == INVALID_PLAYER_ID)
	{
	    PlayerData[playerid][char_last_damaged_weapon] = -1;
    	GivePlayerHealth(playerid, -amount);

		new str[128];
		format(str, sizeof(str), "%s lost HP by falling (ping: %d) HP: %.1f", PlayerData[playerid][char_name], GetPlayerPing(playerid), PlayerData[playerid][char_health]);
		Log("dmg", str);
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	for(new i=0; i<GetMaxPlayers(); i++)
	    if(IsPlayerConnected(i))
	        if(PlayerData[i][char_spectate_id] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	            SetPlayerInterior(i, newinteriorid);
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new i = GetNearestDoors(playerid, 2.0);

	if(i != -1 && Doors[i][samp_id] == pickupid)
	{
	    new count = 0;
		for(new g=0; g<GetMaxPlayers(); g++)
		    if(IsPlayerConnected(g) && PlayerData[g][char_logged] && PlayerData[g][char_inside_doors] == i)
		        count++;

	    new str[128];
	    format(str, sizeof(str), "%s~n~~n~~y~Aby wejsc, wcisnij jednoczesnie~n~~w~~k~~SNEAK_ABOUT~ i ~k~~PED_SPRINT~~n~~n~%d osob w srodku.", Doors[i][Name], count);
	    InfoTD(playerid, str);

	    PlayerData[playerid][char_info_timer] = 5;
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid, 255, PlayerData[playerid][char_skin], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	PlayerData[playerid][char_edit_object] = objectid;
	CancelSelectTextDraw(playerid);
	return 0;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if(PlayerData[playerid][char_spectate_id] != -1)
	{
	    new id = PlayerData[playerid][char_spectate_id];
	    if(GetPlayerVirtualWorld(id) != GetPlayerVirtualWorld(playerid))
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	}

    if(PlayerData[playerid][char_edit_object] != -1 && PlayerData[playerid][char_editing])
	{
	    new Keys, u, p, Float:X, Float:Y, Float:Z;
		GetPlayerKeys(playerid, Keys, u, p);
		new uid = GetObjectUID(PlayerData[playerid][char_edit_object]);

		if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_POS)
		{
			if(u == KEY_UP)
			{
			    if(Keys & KEY_JUMP)
			    {
			        if(Keys & KEY_SPRINT)
			        {
			            GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+1.0);

    					Object[uid][object_pos][2] += 1.0;
					}
					else if(Keys & KEY_WALK)
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+0.01);

    					Object[uid][object_pos][2] += 0.01;
					}
					else
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z+0.5);

    					Object[uid][object_pos][2] += 0.5;
					}
				}
		    	else if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+1.0, Y, Z);

		        	Object[uid][object_pos][0] += 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+0.01, Y, Z);

			    	Object[uid][object_pos][0] += 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X+0.5, Y, Z);

			    	Object[uid][object_pos][0] += 0.5;
				}
			}
			else if(u == KEY_DOWN)
			{
			    if(Keys & KEY_JUMP)
			    {
			        if(Keys & KEY_SPRINT)
			        {
			            GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-1.0);

    					Object[uid][object_pos][2] -= 1.0;
					}
					else if(Keys & KEY_WALK)
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-0.01);

    					Object[uid][object_pos][2] -= 0.01;
					}
					else
					{
					    GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
    					SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z-0.5);

    					Object[uid][object_pos][2] -= 0.5;
					}
				}
		    	else if(Keys == KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-1.0, Y, Z);

		        	Object[uid][object_pos][0] -= 1.0;
				}
				else if(Keys == KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-0.01, Y, Z);

			    	Object[uid][object_pos][0] -= 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X-0.5, Y, Z);

			    	Object[uid][object_pos][0] -= 0.5;
				}
			}
			else if(p == KEY_LEFT)
			{
		    	if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+1.0, Z);

		        	Object[uid][object_pos][1] += 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+0.01, Z);

			    	Object[uid][object_pos][1] += 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y+0.5, Z);

			    	Object[uid][object_pos][1] += 0.5;
				}
			}
			else if(p == KEY_RIGHT)
			{
		    	if(Keys & KEY_SPRINT)
		    	{
		        	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
		        	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-1.0, Z);

		        	Object[uid][object_pos][1] -= 1.0;
				}
				else if(Keys & KEY_WALK)
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-0.01, Z);

			    	Object[uid][object_pos][1] -= 0.01;
				}
				else
				{
			    	GetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y, Z);
			    	SetDynamicObjectPos(PlayerData[playerid][char_edit_object], X, Y-0.5, Z);

			    	Object[uid][object_pos][1] -= 0.5;
				}
			}
		}
		else if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_ROT)
		{
 			if(u == KEY_UP)
 			{
 			    if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+0.1, Z);

					Object[uid][object_pos][4] += 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+10, Z);

					Object[uid][object_pos][4] += 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y+5, Z);

					Object[uid][object_pos][4] += 5.0;
				}
			}
			else if(u == KEY_DOWN)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-0.1, Z);

					Object[uid][object_pos][4] -= 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-10, Z);

					Object[uid][object_pos][4] -= 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y-5, Z);

					Object[uid][object_pos][4] -= 5.0;
				}
			}
			else if(p == KEY_RIGHT)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-0.1);

					Object[uid][object_pos][5] -= 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-10);

					Object[uid][object_pos][5] -= 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z-5);

					Object[uid][object_pos][5] -= 5.0;
				}
			}
			else if(p == KEY_LEFT)
			{
   				if(Keys & KEY_WALK)
 			    {
 			        GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+0.1);

					Object[uid][object_pos][5] += 0.1;
				}
				else if(Keys & KEY_SPRINT)
				{
				    GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+10);

					Object[uid][object_pos][5] += 10.0;
				}
				else
				{
					GetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z);
					SetDynamicObjectRot(PlayerData[playerid][char_edit_object], X, Y, Z+5);

					Object[uid][object_pos][5] += 5.0;
				}
			}
		}
	}
   	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new panels, doors, lights, tires, uid = GetVehicleUID(vehicleid);
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    Vehicle[uid][veh_tires] = tires;
    Vehicle[uid][veh_doors] = doors;
    Vehicle[uid][veh_panels] = panels;
    Vehicle[uid][veh_lights] = lights;

    new DB_Query[256];
	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_vehicles` SET ``veh_tires` = %d, `veh_doors` = %d, `veh_panels` = %d, `veh_lights` = %d WHERE `veh_uid` = %d LIMIT 1",
	    Vehicle[uid][veh_tires], Vehicle[uid][veh_doors], Vehicle[uid][veh_panels], Vehicle[uid][veh_lights], Vehicle[uid][veh_uid]);
	mysql_query(DB_Query);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	for(new i=0; i<MAX_ITEMS; i++)
	    if(Item[i][Owner] == PlayerData[playerid][char_uid])
	        if(Item[i][Active])
	            Item[i][Active] = false;

	Info(playerid, "Twoja postac stracila przytomnosc. Ten stan potrwa okolo 3 minuty.");
	GetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
 	PlayerData[playerid][char_bw] = 180;
  	SetPlayerHealthEx(playerid, 9);

	UpdateNick(playerid);
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success)
		InfoTD(playerid, "~w~Nie mozesz skorzystac z takiej komendy. Uzyj ~y~/pomoc~w~, jezeli szukasz pomocy."), PlayerData[playerid][char_info_timer] = 5;
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == D_LOGIN)
	{
	    if(!response)
	    {
			ShowLoginDialog(playerid, 3);
		}
		else
		{
		    if(PlayerData[playerid][char_guid] == 0)
		    {
				new DB_Query[1000], name[24], password[64], data[1000];
				GetPlayerName(playerid, name, sizeof(name));
				format(DB_Query, sizeof(DB_Query), "SELECT `char_uid`, `global_id`, `char_name`, `char_password` FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
				mysql_query(DB_Query);
				mysql_store_result();
				
				if(mysql_fetch_row_format(data, "|"))
				{
					sscanf(data, "p<|>dds[24]s[64]", PlayerData[playerid][char_uid], PlayerData[playerid][char_guid], PlayerData[playerid][char_name], password);
				}
				
				if(strcmp(password, inputtext, false) || strlen(inputtext) == 0)
		    	{
		        	ShowLoginDialog(playerid, 1);
		        	GameTextForPlayer(playerid, "~r~BLEDNE HASLO!", 5000, 4);
					return 1;
				}
				else
				{
				    mysql_free_result();
				    
				    format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
					mysql_query(DB_Query);
					mysql_store_result();
				
				    if(mysql_fetch_row_format(data, "|"))
					{
				    	sscanf(data, "p<|>dds[24]s[64]dfffffdddddddddddddddddddddddddd",
							PlayerData[playerid][char_uid],
							PlayerData[playerid][char_guid],
							PlayerData[playerid][char_name],
							password,
							PlayerData[playerid][char_admin_level],
							PlayerData[playerid][char_health],
							PlayerData[playerid][char_last_pos][0],
							PlayerData[playerid][char_last_pos][1],
							PlayerData[playerid][char_last_pos][2],
							PlayerData[playerid][char_last_pos][3],
							PlayerData[playerid][char_interior],
							PlayerData[playerid][char_virtual_world],
							PlayerData[playerid][char_cash],
							PlayerData[playerid][char_bank],
							PlayerData[playerid][char_skin],
							PlayerData[playerid][char_strength],
							PlayerData[playerid][char_sex],
							PlayerData[playerid][char_bw],
							PlayerData[playerid][char_premium],
							PlayerData[playerid][char_online],
							PlayerData[playerid][char_score],
							PlayerData[playerid][char_last_damaged_weapon],
							PlayerData[playerid][char_body_part_damaged][0],
							PlayerData[playerid][char_body_part_damaged][1],
							PlayerData[playerid][char_body_part_damaged][2],
							PlayerData[playerid][char_body_part_damaged][3],
							PlayerData[playerid][char_body_part_damaged][4],
							PlayerData[playerid][char_body_part_damaged][5],
							PlayerData[playerid][char_body_part_damaged][6],
							PlayerData[playerid][char_debt],
							PlayerData[playerid][char_bank_number],
							PlayerData[playerid][char_weight],
							PlayerData[playerid][char_height],
							PlayerData[playerid][char_age],
							PlayerData[playerid][char_ingame],
							PlayerData[playerid][char_lastonline]);
					}
					mysql_free_result();
					PlayerData[playerid][char_bank_number] += PlayerData[playerid][char_uid];

					SetPlayerName(playerid, PlayerData[playerid][char_name]);

					PlayerData[playerid][char_logged] = true;
					PlayerData[playerid][char_ingame] = 1;

					if(PlayerData[playerid][char_premium] > gettime())
					{
						new String[128];
						format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). {FFD700}Posiadasz konto premium. Ekipa eQualityGaming ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    					SendClientMessage(playerid, 0xC32F1AFF, String);

    					SetPlayerColor(playerid, 0xFFD700FF);

    					UpdateNick(playerid);
					}
					else
					{
				    	new String[128];
						format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). Ekipa eQualityGaming ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    					SendClientMessage(playerid, 0xC32F1AFF, String);

    					SetPlayerColor(playerid, 0xFFFFFF00);

    					UpdateNick(playerid);
					}

					format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET `char_ingame` = 1 WHERE `global_id` = %d LIMIT 1", PlayerData[playerid][char_guid]);
					mysql_query(DB_Query);

					SetSpawnInfo(playerid, 255, PlayerData[playerid][char_skin], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3], 0, 0, 0, 0, 0, 0);
                	TogglePlayerSpectating(playerid, 0);
					TogglePlayerControllable(playerid, 1);
				}
			}
			else
			{
		    	new names[24];
		    	GetPlayerName(playerid, names, sizeof(names));

		    	new DB_Query[1000], data[1000], password[64], salt[11];
				format(DB_Query, sizeof(DB_Query), "SELECT `members_pass_hash`, `members_pass_salt` FROM `members` WHERE `member_id` = %d LIMIT 1", PlayerData[playerid][char_guid]);
				mysql_query(DB_Query);

				mysql_store_result();

				if(mysql_fetch_row_format(data, "|"))
				{
			    	sscanf(data, "p<|>s[64]s[11]", password, salt);
				}

				mysql_free_result();

		    	if(!strcmp(HashPassword(inputtext, salt), password, true) && strlen(inputtext) != 0)
		    	{
		        	format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", names);
					mysql_query(DB_Query);

		        	mysql_store_result();

					if(mysql_fetch_row_format(data, "|"))
					{
				    	sscanf(data, "p<|>dds[24]s[64]dfffffdddddddddddddddddddddddddd",
							PlayerData[playerid][char_uid],
							PlayerData[playerid][char_guid],
							PlayerData[playerid][char_name],
							password,
							PlayerData[playerid][char_admin_level],
							PlayerData[playerid][char_health],
							PlayerData[playerid][char_last_pos][0],
							PlayerData[playerid][char_last_pos][1],
							PlayerData[playerid][char_last_pos][2],
							PlayerData[playerid][char_last_pos][3],
							PlayerData[playerid][char_interior],
							PlayerData[playerid][char_virtual_world],
							PlayerData[playerid][char_cash],
							PlayerData[playerid][char_bank],
							PlayerData[playerid][char_skin],
							PlayerData[playerid][char_strength],
							PlayerData[playerid][char_sex],
							PlayerData[playerid][char_bw],
							PlayerData[playerid][char_premium],
							PlayerData[playerid][char_online],
							PlayerData[playerid][char_score],
							PlayerData[playerid][char_last_damaged_weapon],
							PlayerData[playerid][char_body_part_damaged][0],
							PlayerData[playerid][char_body_part_damaged][1],
							PlayerData[playerid][char_body_part_damaged][2],
							PlayerData[playerid][char_body_part_damaged][3],
							PlayerData[playerid][char_body_part_damaged][4],
							PlayerData[playerid][char_body_part_damaged][5],
							PlayerData[playerid][char_body_part_damaged][6],
							PlayerData[playerid][char_debt],
							PlayerData[playerid][char_bank_number],
							PlayerData[playerid][char_weight],
							PlayerData[playerid][char_height],
							PlayerData[playerid][char_age],
							PlayerData[playerid][char_ingame],
							PlayerData[playerid][char_lastonline]);
					}
					mysql_free_result();
					PlayerData[playerid][char_bank_number] += PlayerData[playerid][char_uid];

					SetPlayerName(playerid, PlayerData[playerid][char_name]);

					PlayerData[playerid][char_logged] = true;
					PlayerData[playerid][char_ingame] = 1;

					if(PlayerData[playerid][char_premium] > gettime())
					{
						new String[128];
						format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). {FFD700}Posiadasz konto premium. Ekipa eQualityGaming ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    					SendClientMessage(playerid, 0xC32F1AFF, String);

    					SetPlayerColor(playerid, 0xFFD700FF);

    					UpdateNick(playerid);
					}
					else
					{
				    	new String[128];
						format(String, sizeof(String), "Witaj, %s (GUID: %d, UID: %d, ID: %d). Ekipa eQualityGaming ¿yczy mi³ej gry!", PlayerName(playerid), PlayerData[playerid][char_guid], PlayerData[playerid][char_uid], playerid);
    					SendClientMessage(playerid, 0xC32F1AFF, String);

    					SetPlayerColor(playerid, 0xFFFFFF00);

    					UpdateNick(playerid);
					}

					format(DB_Query, sizeof(DB_Query), "UPDATE `rp_chars` SET `char_ingame` = 1 WHERE `global_id` = %d LIMIT 1", PlayerData[playerid][char_guid]);
					mysql_query(DB_Query);

					SetSpawnInfo(playerid, 255, PlayerData[playerid][char_skin], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3], 0, 0, 0, 0, 0, 0);
                	TogglePlayerSpectating(playerid, 0);
					TogglePlayerControllable(playerid, 1);
				}
				else
				{
			    	ShowLoginDialog(playerid, 1);
		        	GameTextForPlayer(playerid, "~r~BLEDNE HASLO!", 5000, 4);
					return 1;
				}
			}
		}
	}
	if(dialogid == D_LOGIN_CN)
	{
	    if(response)
	    {
	        if(strlen(inputtext) == 0)
				return ShowLoginDialog(playerid, 2);

			new name[24];
			format(name, sizeof(name), "%s", inputtext);
			strreplace(name, " ", "_");
	        SetPlayerName(playerid, name);

	        new DB_Query[128];
			format(DB_Query, sizeof(DB_Query), "SELECT `global_id` FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
			mysql_query(DB_Query);

			mysql_store_result();

			if(mysql_num_rows() != 0)
			{
				PlayerData[playerid][char_guid] = mysql_fetch_int();
				ShowLoginDialog(playerid, 1);
			}
			else
			{
	    		ShowLoginDialog(playerid, 2);
			}

			mysql_free_result();
		}
		else
		{
			new str[1000], data[1000], surname[32], uid;
			mysql_query("SELECT * FROM `rp_surnames`");
			mysql_store_result();

			while(mysql_fetch_row_format(data, "|"))
			{
				sscanf(data, "p<|>ds[32]", uid, surname);
				format(str, sizeof(str), "%s\n%s", str, surname);
			}

			mysql_free_result();

		    ShowPlayerDialog(playerid, D_CREATE_CHAR, DIALOG_STYLE_LIST, "Tworzenie postaci", str, "Kobieta", "Mê¿czyzna");
		}
	}

	if(dialogid == D_CREATE_CHAR)
	{
		if(response)
		{
			PlayerData[playerid][char_sex] = 1;
			format(PlayerData[playerid][char_name], 24, "%s", inputtext);
			
			new str[1000], data[1000], name[24], uid, sex;
			mysql_query("SELECT * FROM `rp_firstnames` WHERE `name_sex` = 1");
			mysql_store_result();
			
			while(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>ds[24]d", uid, name, sex);
			    format(str, sizeof(str), "%s\n%s", str, name);
			}
			
			mysql_free_result();
			
			ShowPlayerDialog(playerid, D_CREATE_CHAR2, DIALOG_STYLE_LIST, "Tworzenie postaci", str, "Stwórz", "Anuluj");
		}
		else
		{
			PlayerData[playerid][char_sex] = 0;
			format(PlayerData[playerid][char_name], 24, "%s", inputtext);

			new str[1000], data[1000], name[24], uid, sex;
			mysql_query("SELECT * FROM `rp_firstnames` WHERE `name_sex` = 0");
			mysql_store_result();

			while(mysql_fetch_row_format(data, "|"))
			{
			    sscanf(data, "p<|>ds[24]d", uid, name, sex);
			    format(str, sizeof(str), "%s\n%s", str, name);
			}

			mysql_free_result();

			ShowPlayerDialog(playerid, D_CREATE_CHAR2, DIALOG_STYLE_LIST, "Tworzenie postaci", str, "Stwórz", "Anuluj");
		}
	}
	
	if(dialogid == D_CREATE_CHAR2)
	{
	    if(response)
	    {
	        new name[24];
	        format(name, sizeof(name), "%s_%s", inputtext, PlayerData[playerid][char_name]);
			SetPlayerName(playerid, name);
			
			format(PlayerData[playerid][char_name], 24, "%s", name);
			
			new DB_Query[256];
			format(DB_Query, sizeof(DB_Query), "SELECT `global_id` FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
			mysql_query(DB_Query);
			
			mysql_store_result();
			if(mysql_num_rows() != 0)
		 	{
		 	    Tip(playerid, "Postaæ pod tym imieniem i nazwiskiem ju¿ istnieje, spróbuj stworzyæ inn¹.");
		 	    
		 	    new str[64];
		 	    format(str, sizeof(str), "Niezalogowany_%d", playerid);
		 	    SetPlayerName(playerid, str);
		 	    
		 	    format(PlayerData[playerid][char_name], 24, "%s", PlayerName(playerid));
	 			TryLogin(playerid);
	 			mysql_free_result();
	 			return 1;
			}
			mysql_free_result();
	    
	        ShowPlayerDialog(playerid, D_CREATE_CHAR3, DIALOG_STYLE_INPUT, "Tworzenie postaci", "Wed³ug wzoru, wpisz wiek, wagê, wzrost postaci oraz has³o dostêpu:\n\n(*) Przyk³ad: 22 70 195 testowe\nPostaæ ma 22 lata, wa¿y 70kg i ma 195cm wzrostu a has³em dostêpu jest: 'testowe'.", "Stwórz", "Anuluj");
		}
		else
		{
		    format(PlayerData[playerid][char_name], 24, "%s", PlayerName(playerid));
			TryLogin(playerid);
		}
	}
	
	if(dialogid == D_CREATE_CHAR3)
	{
	    if(response)
	    {
	        new wiek, waga, wzrost, haslo[32];
	        if(sscanf(inputtext, "p< >ddds[32]", wiek, waga, wzrost, haslo)) return ShowPlayerDialog(playerid, D_CREATE_CHAR3, DIALOG_STYLE_INPUT, "Tworzenie postaci", "Wed³ug wzoru, wpisz wiek, wagê, wzrost postaci oraz has³o dostêpu:\n\n(*) Przyk³ad: 22 70 195 testowe\nPostaæ ma 22 lata, wa¿y 70kg i ma 195cm wzrostu a has³em dostêpu jest: 'testowe'.", "Stwórz", "Anuluj");
			
			PlayerData[playerid][char_age] = wiek;
			PlayerData[playerid][char_weight] = waga;
			PlayerData[playerid][char_height] = wzrost;
			
			new DB_Query[1200];
			format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_chars` (`char_uid`, `global_id`, `char_name`, `char_password`, `char_admin_level`, `char_health`, `char_last_pos_x`, `char_last_pos_y`, `char_last_pos_z`, `char_last_pos_a`, `char_interior`, `char_virtual_world`, `char_cash`, `char_bank`, `char_skin`, `char_strength`, `char_sex`, `char_bw`, `char_premium`, `char_online`, `char_score`, `char_last_damaged_weapon`, `char_bodypart_damaged_torso`, `char_bodypart_damaged_groin`, `char_bodypart_damaged_leftarm`, `char_bodypart_damaged_rightarm`, `char_bodypart_damaged_leftleg`, `char_bodypart_damaged_rightleg`, `char_bodypart_damaged_head`, `char_debt`, `char_bank_number`, `char_weight`, `char_height`, `char_age`, `char_ingame`, `char_lastonline`) VALUES (NULL, '0', '%s', '%s', '0', '100', '0', '0', '0', '0', '0', '0', '100', '75', '1', '3000', '%d', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1000000000', '%d', '%d', '%d', '0', '0')",
			    PlayerData[playerid][char_name], haslo, PlayerData[playerid][char_sex], PlayerData[playerid][char_weight], PlayerData[playerid][char_height], PlayerData[playerid][char_age]);
			mysql_query(DB_Query);
			
			Tip(playerid, "Postaæ zosta³a pomyœlnie utworzona. Zaloguj siê u¿ywaj¹c has³a które poda³eœ wczeœniej.");
			
			TryLogin(playerid);
		}
		else
		{
			format(PlayerData[playerid][char_name], 24, "%s", PlayerName(playerid));
		    TryLogin(playerid);
		}
	}

	if(dialogid == D_ITEMS)
	{
		if(response)
		{
			switch(listitem)
			{
			    case 0:{ return cmd_p(playerid, ""); }
			    case 1:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 2:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 3:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 4:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 5:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 6:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 7:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 8:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 9:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 10:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 11:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 12:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 13:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 14:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 15:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 16:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 17:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 18:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 19:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
				case 20:{ new uid = strval(inputtext[0]); UseItem(playerid, uid); }
			}
		}
		else if(!response)
		{
			switch(listitem)
			{
			    case 0:{ /*nothing*/ }
			    case 1:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 2:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 3:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 4:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 5:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 6:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 7:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 8:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 9:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 10:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 11:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 12:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 13:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 14:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 15:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 16:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 17:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 18:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 19:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
				case 20:{ FreeID[playerid] = strval(inputtext[0]), ShowPlayerDialog(playerid, D_ITEM_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "Przedmioty » Opcje", "ID\tOpcja\n0\tOd³ó¿ przedmiot", "Wybierz", "Cofnij"); }
			}
		}
	}

	if(dialogid == D_ITEM_OPTIONS)
	{
		if(!response)
		{
		    return cmd_p(playerid, "");
		}
		else
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            new uid = FreeID[playerid];

		            if(Item[uid][Active]) return Info(playerid, "Ten przedmiot nie mo¿e byæ aktywny.");

		            if(IsPlayerInAnyVehicle(playerid))
		            {
		                Item[uid][Owner] = 0;
		                Item[uid][in_vehicle] = GetVehicleUID(GetPlayerVehicleID(playerid));

						FreeID[playerid] = -1;

						cmd_me(playerid, "odk³ada jakiœ przedmiot w pojeŸdzie.");
						return 1;
					}

		            new Float:X, Float:Y, Float:Z;
		            GetPlayerPos(playerid, X, Y, Z);

		            Item[uid][Owner] = 0;
		            Item[uid][item_pos][0] = X;
		            Item[uid][item_pos][1] = Y;
		            Item[uid][item_pos][2] = Z;

		            FreeID[playerid] = -1;

		            cmd_me(playerid, "odk³ada jakiœ przedmiot.");
				}
			}
		}
	}

	if(dialogid == D_NEAREST_ITEMS)
	{
	    if(response)
	    {
			new uid = strval(inputtext[0]);

			if(Item[uid][Owner] != 0 && Item[uid][Owner] != PlayerData[playerid][char_uid]) return Info(playerid, "Nie mo¿esz podnieœæ tego przedmiotu.");

			if(Item[uid][in_vehicle] != 0 && IsPlayerInAnyVehicle(playerid))
			{
   				Item[uid][Owner] = PlayerData[playerid][char_uid];
			    Item[uid][in_vehicle] = 0;

			    cmd_me(playerid, "podnosi jakiœ przedmiot ze schowka w pojeŸdzie.");
			    return 1;
			}

			Item[uid][Owner] = PlayerData[playerid][char_uid];
			Item[uid][item_pos][0] = 0;
			Item[uid][item_pos][1] = 0;
			Item[uid][item_pos][2] = 0;

			cmd_me(playerid, "podnosi jakiœ przedmiot z ziemi.");
		}
	}

	if(dialogid == D_CREATE_ITEM)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0:{ ShowPlayerDialog(playerid, D_CT_CHANGE_NAME, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana nazwy", "Podaj now¹ nazwê przedmiotu:", "Zmieñ", "Cofnij"); }
			    case 1:{ ShowPlayerDialog(playerid, D_CT_CHANGE_TYPE, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana typu", "Podaj typ przedmiotu:", "Zmieñ", "Cofnij"); }
			    case 2:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_1, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (1)", "Podaj now¹ wartoœæ (1):", "Zmieñ", "Cofnij"); }
			    case 3:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_2, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (2)", "Podaj now¹ wartoœæ (2):", "Zmieñ", "Cofnij"); }
			    case 4:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_3, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (3)", "Podaj now¹ wartoœæ (3):", "Zmieñ", "Cofnij"); }
			    case 5:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_4, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (4)", "Podaj now¹ wartoœæ (4):", "Zmieñ", "Cofnij"); }
			    case 6:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_5, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (5)", "Podaj now¹ wartoœæ (5):", "Zmieñ", "Cofnij"); }
			    case 7:{ ShowPlayerDialog(playerid, D_CT_CHANGE_VAR_6, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana wartoœci (6)", "Podaj now¹ wartoœæ (6):", "Zmieñ", "Cofnij"); }
				case 8:{ ShowPlayerDialog(playerid, D_CT_CHANGE_OWNER, DIALOG_STYLE_INPUT, "Tworzenie przedmiotu » Zmiana ownera", "Podaj UID postaci aby nadaæ ownera:", "Zmieñ", "Cofnij"); }
				case 9:
				{
				    new uid = FreeID[playerid];
				    Item[uid][UID] = uid;

					new DB_Query[500];
					format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_items` (item_name, item_owner, item_type, item_var1, item_var2, item_var3, item_var4, item_var5, item_var6) VALUES ('%s', %d, %d, %d, %d, %d, %d, %d, %d)",
						Item[uid][Name], Item[uid][Owner], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5]);
					mysql_query(DB_Query);

				    FreeID[playerid] = -1;

				    Tip(playerid, "Przedmiot zosta³ utworzony.");
				}
			}
		}
	}

	if(dialogid == D_CT_CHANGE_NAME)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    format(Item[uid][Name], 64, "%s", inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_TYPE)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Type] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_1)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][0] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_2)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][1] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_3)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][2] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_4)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][3] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_5)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][4] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_VAR_6)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Var][5] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_CT_CHANGE_OWNER)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
		else
		{
		    new uid = FreeID[playerid];
		    Item[uid][Owner] = strval(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nNazwa przedmiotu:\t%s\nTyp przedmiotu:\t%d\nWartoœæ (1):\t%d\nWartoœæ (2):\t%d\nWartoœæ (3):\t%d\n\
				Wartoœæ (4):\t%d\nWartoœæ (5):\t%d\nWartoœæ (6):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz przedmiot", Item[uid][Name], Item[uid][Type], Item[uid][Var][0], Item[uid][Var][1], Item[uid][Var][2], Item[uid][Var][3], Item[uid][Var][4], Item[uid][Var][5], Item[uid][Owner]);

			ShowPlayerDialog(playerid, D_CREATE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie przedmiotu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLES)
	{
	    if(response)
	    {
			new uid = strval(inputtext[0]);
			if(Vehicle[uid][veh_spawned])
			{
			    if(IsVehicleOccupied(Vehicle[uid][samp_id]))
			        return GameTextForPlayer(playerid, "~r~NIE MOZESZ TEGO TERAZ ZROBIC!", 3000, 4);

			    DestroyVehicle(Vehicle[uid][samp_id]);
			    Vehicle[uid][veh_spawned] = false;
			    SaveVehicle(uid);
			    //Vehicle[uid][veh_pos][0] = 0.0;
			    //Vehicle[uid][veh_pos][1] = 0.0;
			    //Vehicle[uid][veh_pos][2] = 0.0;
			    return cmd_v(playerid, "");
			}
			else
			{
			    new bool:found = false;
			    for(new i=0; i<MAX_VEHICLES; i++)
			    {
			        new uid2 = GetVehicleUID(i);
			        if(GetVehicleDistanceFromPoint(i, Vehicle[uid2][veh_pos][0], Vehicle[uid2][veh_pos][1], Vehicle[uid2][veh_pos][2]) <= 3.0 && Vehicle[uid2][veh_spawned])
			        {
						found = true;
						break;
					}
				}
				if(found) return InfoTD(playerid, "Miejsce zajete, odczekaj chwile lub uzyj /v reset."), PlayerData[playerid][char_info_timer] = 8;

                Vehicle[uid][samp_id] = CreateVehicle(Vehicle[uid][veh_model], Vehicle[uid][veh_pos][0], Vehicle[uid][veh_pos][1], Vehicle[uid][veh_pos][2], Vehicle[uid][veh_pos][3], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], -1, 0);
				ChangeVehiclePaintjob(Vehicle[uid][samp_id], Vehicle[uid][veh_paintjob]);
				SetVehicleHealth(Vehicle[uid][samp_id], Vehicle[uid][veh_health]);
				Vehicle[uid][veh_spawned] = true;
				Vehicle[uid][veh_locked] = true;

				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, doors, bonnet, boot, objective);

				SetVehicleParamsEx(Vehicle[uid][samp_id], engine, lights, alarm, 1, bonnet, boot, objective);

				UpdateVehicleDamageStatus(Vehicle[uid][samp_id], Vehicle[uid][veh_panels], Vehicle[uid][veh_doors], Vehicle[uid][veh_lights], Vehicle[uid][veh_tires]);

				return cmd_v(playerid, "");
			}
		}
	}

	if(dialogid == D_CREATE_VEHICLE)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:{ ShowPlayerDialog(playerid, D_VEHICLE_CN, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana pojazdu", "Podaj now¹ nazwê pojazdu:", "Zmieñ", "Cofnij"); }
	            case 1:{ ShowPlayerDialog(playerid, D_VEHICLE_CHP, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana HP", "Podaj now¹ wartoœæ HP pojazdu:", "Zmieñ", "Cofnij"); }
	            case 2:{ ShowPlayerDialog(playerid, D_VEHICLE_CK1, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana koloru (1)", "Podaj nowy kolor pojazdu (1):", "Zmieñ", "Cofnij"); }
	            case 3:{ ShowPlayerDialog(playerid, D_VEHICLE_CK2, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana koloru (2)", "Podaj nowy kolor pojazdu (2):", "Zmieñ", "Cofnij"); }
	            case 4:{ ShowPlayerDialog(playerid, D_VEHICLE_CO, DIALOG_STYLE_INPUT, "Tworzenie pojazdu » Zmiana ownera", "Podaj UID postaci która ma byæ w³aœcicielem pojazdu:", "Zmieñ", "Cofnij"); }
	            case 5:
	            {
	                new uid = FreeID[playerid];
	                Vehicle[uid][veh_uid] = uid;
	                Vehicle[uid][veh_fuel] = 100.0;
	                Vehicle[uid][veh_mileage] = 0.0;
					Vehicle[uid][veh_pos][0] = 872.5438;
					Vehicle[uid][veh_pos][1] = -1259.9264;
					Vehicle[uid][veh_pos][2] = 14.9351;
					Vehicle[uid][veh_pos][3] = 349.0438;
					Vehicle[uid][veh_paintjob] = 3;

					new DB_Query[500];
					format(DB_Query, sizeof(DB_Query), "INSERT INTO `rp_vehicles` (`veh_model`, `veh_health`, `veh_pos_x`, `veh_pos_y`, `veh_pos_z`, `veh_pos_a`, `veh_color1`, `veh_color2`, `veh_tires`, `veh_doors`, `veh_panels`, `veh_lights`, `veh_world`, `veh_interior`, `veh_fuel`, `veh_mileage`, `veh_owner`) VALUES (%d, %f, 872.5438, -1259.9264, 14.9351, 349.0438, %d, %d, 0, 0, 0, 0, 0, 0, 100.0, 0.0, %d)",
						Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);
	                mysql_query(DB_Query);

	                FreeID[playerid] = -1;
	            }
			}
		}
	}

	if(dialogid == D_VEHICLE_CN)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

		if(response)
		{
		    new uid = FreeID[playerid];
		    Vehicle[uid][veh_model] = GetVehicleModelIDFromName(inputtext);

		    new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CHP)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_health] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CK1)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_color][0] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CK2)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_color][1] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_CO)
	{
	    if(!response)
	    {
	        new uid = FreeID[playerid];
	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
			return 1;
		}

	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Vehicle[uid][veh_owner] = strval(inputtext);

	        new StrinG[1000];
			format(StrinG, sizeof(StrinG), "Ustawienia\tWartoœci\nPojazd:\t%s(ID: %d)\nHP:\t%.1f\nKolor (1):\t%d\nKolor (2):\t%d\nOwner:\t%d\nZatwierdŸ, stwórz pojazd",
				VehicleNames[Vehicle[uid][veh_model] - 400], Vehicle[uid][veh_model], Vehicle[uid][veh_health], Vehicle[uid][veh_color][0], Vehicle[uid][veh_color][1], Vehicle[uid][veh_owner]);

			ShowPlayerDialog(playerid, D_CREATE_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Tworzenie pojazdu", StrinG, "ZatwierdŸ", "Anuluj");
		}
	}

	if(dialogid == D_ITEM_DISC)
	{
	    if(response)
		{
			new uid = FreeID[playerid];
			format(Item[uid][Name], 64, "P³yta CD: %s", inputtext);

		    ShowPlayerDialog(playerid, D_ITEM_DISC2, DIALOG_STYLE_INPUT, "Tworzenie p³yty » Link", "WprowadŸ link do audio streama by nagraæ p³ytê:", "Stwórz", "Zamknij");
		}
	}

	if(dialogid == D_ITEM_DISC2)
	{
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Item[uid][Type] = 3;
			format(Item[uid][Desc], 256, "%s", inputtext);

			FreeID[playerid] = -1;

			Tip(playerid, "P³yta zosta³a stworzona.");
		}
	}

	if(dialogid == D_AREA)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:{ return cmd_area(playerid, ""); }
	            case 1:{ return cmd_area(playerid, ""); }
	            case 2:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_OWNER, DIALOG_STYLE_INPUT, "Strefa » Zmiana w³aœciciela", "WprowadŸ UID postaci która ma byæ nowym w³aœcicielem:", "ZatwierdŸ", "Cofnij"); }
				case 3:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_HOUSE_COST, DIALOG_STYLE_INPUT, "Strefa » Zmiana ceny budynku mieszkalnego", "WprowadŸ cenê (bez $) dla budynków mieszkalnych:", "ZatwierdŸ", "Cofnij"); }
				case 4:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_BUISNESS_COST, DIALOG_STYLE_INPUT, "Strefa » Zmiana ceny budynku biznesowego", "WprowadŸ cenê (bez $) dla budynków biznesowych:", "ZatwierdŸ", "Cofnij"); }
				case 5:{ ShowPlayerDialog(playerid, D_AREA_CHANGE_SIZE, DIALOG_STYLE_INPUT, "Strefa » Zmiana metra¿u dla budynków", "WprowadŸ nowy metra¿ który bêdzie minimalnym metra¿em dla budynków:", "ZatwierdŸ", "Cofnij"); }
			}
		}
		else
		{
		    FreeID[playerid] = -1;
		}
	}

	if(dialogid == D_AREA_CHANGE_OWNER)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_owner] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_owner` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_owner], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_HOUSE_COST)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_house_cost] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_house_cost` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_house_cost], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_BUISNESS_COST)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_buis_cost] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_buis_cost` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_buis_cost], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_AREA_CHANGE_SIZE)
	{
	    if(!response) return cmd_area(playerid, "");
	    if(response)
	    {
	        new uid = FreeID[playerid];
	        Zone[uid][z_size] = strval(inputtext);

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_size` = %d WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_size], uid);
			mysql_query(DB_Query);

			cmd_area(playerid, "");
		}
	}

	if(dialogid == D_BANK)
	{
	    if(response)
	    {
			switch(listitem)
			{
			    case 0:
			    {
			        new StrinG[500];
					format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    	ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
				}
				case 1:{ ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij"); }
				case 2:
				{
				    if(PlayerData[playerid][char_debt] != 0)
				    {
				        Tip(playerid, "Konto zablokowane. Najpierw sp³aæ swoje nale¿noœci!");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
				}
				case 3:
				{
				    if(PlayerData[playerid][char_debt] != 0)
				    {
				        Tip(playerid, "Konto zablokowane. Najpierw sp³aæ swoje nale¿noœci!");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
				}
				case 4:
				{
				    if(PlayerData[playerid][char_debt] == 0)
				    {
				        Tip(playerid, "Nie posiadasz ¿adnych nale¿noœci.");
				        new StrinG[500];
						format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    		ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
						return 1;
					}
					ShowPlayerDialog(playerid, D_BANK_DEBT, DIALOG_STYLE_LIST, "Bankomat » Sp³ata nale¿noœci", "test", "ZatwierdŸ", "Cofnij");
				}
			}
		}
	}

	if(dialogid == D_BANK_WPLAC)
	{
	    if(response)
	    {
	        if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
	        if(PlayerData[playerid][char_cash] < strval(inputtext))
	        {
	            Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki przy sobie.");

	            ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
	            return 1;
			}

			if(strval(inputtext) < 0 || strval(inputtext) > 1500000)
			{
			    Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    ShowPlayerDialog(playerid, D_BANK_WPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wp³aciæ na swoje konto bankowe:", "ZatwierdŸ", "Cofnij");
			    return 1;
			}

	        PlayerData[playerid][char_cash] -= strval(inputtext);
	        PlayerData[playerid][char_bank] += strval(inputtext);

	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_WYPLAC)
	{
	    if(response)
	    {
	        if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
            if(PlayerData[playerid][char_bank] < strval(inputtext))
	        {
	            Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki na koncie.");

	            ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
	            return 1;
			}

			if(strval(inputtext) < 0 || strval(inputtext) > 1500000)
			{
			    Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    ShowPlayerDialog(playerid, D_BANK_WYPLAC, DIALOG_STYLE_INPUT, "Bankomat » Wyp³ata pieniêdzy", "WprowadŸ kwotê jak¹ chcesz wyp³aciæ z bankomatu:", "ZatwierdŸ", "Cofnij");
			    return 1;
			}

	        PlayerData[playerid][char_cash] += strval(inputtext);
	        PlayerData[playerid][char_bank] -= strval(inputtext);

	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_PRZELEW)
	{
	    if(response)
	    {
	        new acnum, amount;
			if(sscanf(inputtext, "p< >dd", acnum, amount))
			{
			    ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
			    return 1;
			}
			else
			{
	        	new player = INVALID_PLAYER_ID;
	        	for(new i=0; i<GetMaxPlayers(); i++)
	        	{
	            	if(IsPlayerConnected(i))
	            	{
	                	if(PlayerData[i][char_bank_number] == acnum)
	                	{
	                    	player = i;
	                    	break;
						}
					}
				}

				if(player == INVALID_PLAYER_ID)
				{
			    	Tip(playerid, "Podany numer konta bankowego nie istnieje.");

			    	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
  					return 1;
				}

				if(PlayerData[playerid][char_bank] < amount)
	        	{
	            	Tip(playerid, "Nie posiadasz wystarczaj¹cej iloœci gotówki na koncie.");

	            	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
	            	return 1;
				}

				if(amount < 0 || amount > 1500000)
				{
			    	Tip(playerid, "Wpisano niepoprawn¹ kwotê.");

			    	ShowPlayerDialog(playerid, D_BANK_PRZELEW, DIALOG_STYLE_INPUT, "Bankomat » Przelew na inne konto", "WprowadŸ numer konta oraz kwotê wed³ug przyk³adu: 3050432 500", "ZatwierdŸ", "Cofnij");
			    	return 1;
				}

				PlayerData[playerid][char_bank] -= amount;
				PlayerData[player][char_bank] += amount;

				new str[128];
				format(str, sizeof(str), "Otrzyma³eœ przelew z numeru konta %d. Dostêpne œrodki: $%d", PlayerData[playerid][char_bank_number], PlayerData[player][char_bank]);
				Tip(player, str);

         		new StrinG[500];
				format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  				ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
			}
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_BANK_DEBT)
	{
	    if(response)
	    {
	        //do zrobienia
	        new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
		else
		{
		    new StrinG[500];
			format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
  			ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
		}
	}

	if(dialogid == D_VEHICLE_INFO)
	{
	    if(response)
	    {
	        new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	        switch(listitem)
	        {
	            case 0:
	            {
					if(bonnet == VEHICLE_PARAMS_ON)
					{
					    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);

					    new str[64];
					    format(str, sizeof(str), "zamyka maskê w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
					else
					{
					    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);

					    new str[64];
					    format(str, sizeof(str), "otwiera maskê w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
	            }
	            case 1:
	            {
	                if(boot == VEHICLE_PARAMS_ON)
	                {
	                    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);

					    new str[64];
					    format(str, sizeof(str), "zamyka baga¿nik w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
					else
					{
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);

					    new str[64];
					    format(str, sizeof(str), "otwiera baga¿nik w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
					}
				}
				case 2:
				{
				    if(lights == VEHICLE_PARAMS_ON)
				    {
				        SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
					}
					else
					{
					    SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
					}
				}
				case 3:
				{
					new driver, passenger, backleft, backright;
				    GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);
				    if(driver == 0 && passenger == 0)
				    {
				        SetVehicleParamsCarWindows(vehicleid, 1, 1, 1, 1);

				        new str[64];
					    format(str, sizeof(str), "zamyka szyby w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
				    }
				    else if(driver == 1 && passenger == 1)
				    {
				        SetVehicleParamsCarWindows(vehicleid, 0, 0, 1, 1);

				        new str[64];
					    format(str, sizeof(str), "otwiera szyby w pojeŸdzie %s", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					    cmd_me(playerid, str);
				    }
				}
				case 4:
				{
				    return cmd_v(playerid, "");
				}
				case 5:
				{
				    new list_players[256];
				    for(new i=0; i<GetMaxPlayers(); i++)
				    {
				        if(IsPlayerConnected(i) && PlayerData[i][char_logged] && i != playerid)
				        {
				            if(PlayerToPlayer(5.0, playerid, i))
				            {
				            	format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerData[i][char_name]);
							}
						}
					}

					if(!strlen(list_players))
					    Info(playerid, "W pobli¿u Twojej postaci nie znaleziono ¿adnych graczy.");
				    else
				    	ShowPlayerDialog(playerid, D_VEHICLE_SELL, DIALOG_STYLE_LIST, "Lista osób w pobli¿u", list_players, "Wybierz", "Cofnij");
				}
				case 6:
				{
				    new list_players[256];
				    for(new i=0; i<GetMaxPlayers(); i++)
				    {
				        if(IsPlayerConnected(i) && PlayerData[i][char_logged] && i != playerid)
				        {
				            if(PlayerToPlayer(5.0, playerid, i))
				            {
				            	format(list_players, sizeof(list_players), "%s\n%d\t%s", list_players, i, PlayerData[i][char_name]);
							}
						}
					}

					if(!strlen(list_players))
					    Info(playerid, "W pobli¿u Twojej postaci nie znaleziono ¿adnych graczy.");
					else
					    ShowPlayerDialog(playerid, D_VEHICLE_GIVE, DIALOG_STYLE_LIST, "Lista osób w pobli¿u", list_players, "Wybierz", "Cofnij");
				}
			}
		}
	}

	if(dialogid == D_VEHICLE_SELL)
	{
	    if(response)
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        new uid = GetVehicleUID(vehicleid);
	        new id = strval(inputtext[0]);

	        new str[500];
	        format(str, sizeof(str), "Oferta sprzeda¿y pojazdu\nKupuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nWpisz kwotê za któr¹ chcesz sprzedaæ pojazd i kliknij \"Sprzedaj\".", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

	        PlayerData[playerid][char_offer_id] = id;

			ShowPlayerDialog(playerid, D_VEHICLE_SELL2, DIALOG_STYLE_INPUT, "Sprzeda¿ pojazdu", str, "Sprzedaj", "Anuluj");
		}

		if(!response)
		{
			return cmd_v(playerid, "");
		}
	}

	if(dialogid == D_VEHICLE_SELL2)
	{
	    if(response)
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        new uid = GetVehicleUID(vehicleid);
	        new id = PlayerData[playerid][char_offer_id];

			GameTextForPlayer(playerid, "~g~Oferta zostala wyslana!", 5000, 4);

			new str[500];
	        format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], strval(inputtext[0]));

			ShowPlayerDialog(PlayerData[playerid][char_offer_id], D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");

			PlayerData[id][char_offer_id] = playerid;
			PlayerData[playerid][char_offer_value] = strval(inputtext[0]);
		}
	}

	if(dialogid == D_VEHICLE_SELL3)
	{
	    new id = PlayerData[playerid][char_offer_id];
	    new vehicleid = GetPlayerVehicleID(id);
    	new uid = GetVehicleUID(vehicleid);

	    if(response)
	    {
	        if(!strcmp(inputtext[0], "potwierdzam", true))
	        {
	        	if(PlayerData[playerid][char_cash] < PlayerData[id][char_offer_value])
	        	{
	        	    new str[500];
	        		format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.\n\n{FF0000}Nie posiadasz wystarczaj¹cej kwoty pieniêdzy przy sobie.", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], PlayerData[id][char_offer_value]);

					ShowPlayerDialog(playerid, D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");
					return 1;
				}

	        	PlayerData[playerid][char_cash] -= PlayerData[id][char_offer_value];
	        	PlayerData[id][char_cash] += PlayerData[id][char_offer_value];
	        	Vehicle[uid][veh_owner] = PlayerData[playerid][char_uid];
	        	SaveVehicle(uid);

	        	GameTextForPlayer(playerid, "~g~Oferta zaakceptowana!", 5000, 4);
	        	GameTextForPlayer(id, "~g~Gracz zaakceptowal oferte!", 5000, 4);

	        	RemovePlayerFromVehicle(id);

	        	PlayerData[id][char_offer_id] = -1;
	        	PlayerData[playerid][char_offer_id] = -1;
	        	PlayerData[id][char_offer_value] = 0;
			}
			else
			{
			    new str[500];
	        	format(str, sizeof(str), "Oferta kupno pojazdu\nSprzedaj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\nCena: $%d\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ kupno pojazdu.\n\n{FF0000}Nie wpisano w okienku \"potwierdzam\".", PlayerData[id][char_name], id, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel], PlayerData[id][char_offer_value]);

				ShowPlayerDialog(playerid, D_VEHICLE_SELL3, DIALOG_STYLE_INPUT, "Kupno pojazdu", str, "Kup", "Anuluj");
			}
		}

		if(!response)
		{
		    PlayerData[playerid][char_offer_id] = -1;
			PlayerData[id][char_offer_id] = -1;
		}
	}

	if(dialogid == D_VEHICLE_GIVE)
	{
	    if(!response)
	    {
	        return cmd_v(playerid, "");
		}

		if(response)
		{
			new str[500], id = strval(inputtext[0]), vehicleid = GetPlayerVehicleID(playerid), uid = GetVehicleUID(vehicleid);
 			format(str, sizeof(str), "Oferta przekazania pojazdu\nPrzekazuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ przekazanie pojazdu.", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

			ShowPlayerDialog(id, D_VEHICLE_GIVE2, DIALOG_STYLE_INPUT, "Przekazanie pojazdu", str, "Odbierz", "Anuluj");

			PlayerData[id][char_offer_id] = playerid;

			GameTextForPlayer(playerid, "~g~Oferta zostala wyslana!", 5000, 4);
		}
	}

	if(dialogid == D_VEHICLE_GIVE2)
	{
	    if(response)
	    {
	        if(!strcmp(inputtext[0], "potwierdzam", true))
	        {
	            new id = PlayerData[playerid][char_offer_id];
	            new vehicleid = GetPlayerVehicleID(id);
	            new uid = GetVehicleUID(vehicleid);

	            Vehicle[uid][veh_owner] = PlayerData[playerid][char_uid];
	            SaveVehicle(uid);

	            GameTextForPlayer(playerid, "~g~Oferta zaakceptowana!", 5000, 4);
	        	GameTextForPlayer(id, "~g~Gracz zaakceptowal oferte!", 5000, 4);

	        	RemovePlayerFromVehicle(id);

	        	PlayerData[id][char_offer_id] = -1;
	        	PlayerData[playerid][char_offer_id] = -1;
			}
			else
			{
			    new str[500], vehicleid = GetPlayerVehicleID(playerid), uid = GetVehicleUID(vehicleid);
 				format(str, sizeof(str), "Oferta przekazania pojazdu\nPrzekazuj¹cy: %s (ID: %d)\nPrzebieg: %.1f\nPaliwo: %.1f\n\nW okienku wpisz \"potwierdzam\" aby zatwierdziæ przekazanie pojazdu.\n\n{FF0000}Nie wpisano w okienku \"potwierdzam\".", PlayerData[playerid][char_name], playerid, Vehicle[uid][veh_mileage], Vehicle[uid][veh_fuel]);

				ShowPlayerDialog(playerid, D_VEHICLE_GIVE2, DIALOG_STYLE_INPUT, "Przekazanie pojazdu", str, "Odbierz", "Anuluj");
			}
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(PlayerData[playerid][char_bw] > 0)
	{
	    Info(playerid, "W tej chwili nie mo¿esz korzystaæ z czatów InCharacter.");
	    return 0;
	}

   	new
	   	string[250],
	   	pytajniki = 0,
	   	kropki = 0,
	    wykrzykniki = 0,
		gwiazdki = 0,
		asterisk = -1,
		skip = 0
	;

	if(text[0] == '.')
	{
	    if(PlayerData[playerid][char_block_ooc] != 0)
	    {
	        Info(playerid, "Posiadasz aktywn¹ blokadê czatów OOC.");
	        return 0;
		}

		format(string, sizeof(string), "(( %s [%d]: %s ))", PlayerName(playerid), playerid, text[1]);
 		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
 		return 0;
	}

    if(text[0] == '?')
	{
		cmd_me(playerid, "robi pytajac¹ minê.");
	    return 0;
	}

	if(text[0] == '*')
	{
	    strdel(text, 0, 1);
	    cmd_me(playerid, text);
	    return 0;
	}

	for (new t=0; t!=strlen(text); t++)
		string[t] = text[t];

 	ReplaceEmoticionsToText(string);

	for(new i = 0; i!=strlen(string); i++)
	{
		if(string[i] == '!') wykrzykniki++;
		if(string[i] == '*') gwiazdki++;
	 	if(string[i] == '.') kropki++;
		if(string[i] == '?') pytajniki++;

		if(string[i] == '*')
		{
			if(asterisk == -1)
			{
				strins(string, "{C2A2DA}", i);
				asterisk = i;
				skip++;
			}
			else
			{
				asterisk = -1;
				if(skip%2 == 0)
				{
					strins(string, "{E6E6E6}", i+1);
				}
			}
		}
	}

    // Pierwsza litera zawsze z duzej litery.
	string[0] = toupper(string[0]);

	if(wykrzykniki >= 2)
	{
		format(string, sizeof string, "%s krzyczy: %s%s", PlayerName(playerid), string, ((kropki+pytajniki+wykrzykniki == 0 ? (".") : (""))) );
		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
	}
	else
	{
		format(string, sizeof string, "%s mówi: %s%s", PlayerName(playerid), string, ((kropki+pytajniki+wykrzykniki == 0 ? (".") : (""))) );
		SendWrappedMessageToPlayerRange(playerid, COLOR_SAY_FADE1, COLOR_SAY_FADE2, COLOR_SAY_FADE3, COLOR_SAY_FADE4, COLOR_SAY_FADE5, string, 10, MAX_LINE);
	}
	return 0;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(IsPlayerAdmin(playerid) || PlayerData[playerid][char_admin_level] > 0)
		SetPlayerPosFindZ(playerid, fX, fY, fZ);
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE)
	{
	    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
	    {
	        new vehid = GetPlayerVehicleID(playerid);
	        new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(vehid,engine,lights,alarm,doors,bonnet,boot,objective);
    		if(lights == 1)
    			SetVehicleParamsEx(vehid,engine,0,alarm,doors,bonnet,boot,objective);
			else
			    SetVehicleParamsEx(vehid,engine,1,alarm,doors,bonnet,boot,objective);
		}

	    if(PlayerData[playerid][char_edit_object] != -1)
	    {
			if(!PlayerData[playerid][char_editing])
			{
				ApplyAnimation(playerid,"BEACH","bather",4.1,0,0,0,1,0);
				PlayerData[playerid][char_editing] = true;

				PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_POS;
			}
			else
			{
		    	ClearAnimations(playerid);
				PlayerData[playerid][char_editing] = false;

				PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_NONE;
			}
		}
	}

	if(newkeys & KEY_AIM)
	{
	    if(PlayerData[playerid][char_edit_object] == -1 && PlayerData[playerid][char_edit_stage] != STAGE_OBJECT_NONE) return 1;

	    if(PlayerData[playerid][char_edit_stage] == STAGE_OBJECT_POS)
	    {
	        PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_ROT;
		}
		else
		{
		    PlayerData[playerid][char_edit_stage] = STAGE_OBJECT_POS;
		}
	}

	if(newkeys & KEY_SPRINT && PlayerData[playerid][char_spectate_id] != -1 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    new id = GetNextPlayerID(playerid, PlayerData[playerid][char_spectate_id]);
	    if(id == INVALID_PLAYER_ID) id = GetLowestID(playerid);

        if(IsPlayerInAnyVehicle(id))
		    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		else
        	PlayerSpectatePlayer(playerid, id);

		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

		PlayerData[playerid][char_spectate_id] = id;
	}
	if(newkeys & KEY_WALK && PlayerData[playerid][char_spectate_id] != -1 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    new id = GetPreviousPlayerID(playerid, PlayerData[playerid][char_spectate_id]);
	    if(id == INVALID_PLAYER_ID) id = GetPlayerPoolSize();

	    if(IsPlayerInAnyVehicle(id))
		    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id));
		else
        	PlayerSpectatePlayer(playerid, id);

		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

		PlayerData[playerid][char_spectate_id] = id;
	}

	if(newkeys & KEY_ACTION && GetPlayerVehicleSeat(playerid) == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        new vehid = GetPlayerVehicleID(playerid);
		    new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(vehid,engine,lights,alarm,doors,bonnet,boot,objective);
    		if(engine == 0)
    			SetTimerEx("EngineStart", 3000, false, "d", playerid), GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~TRWA ODPALANIE SILNIKA...", 3500, 3);
			else
			    SetVehicleParamsEx(vehid,0,lights,alarm,doors,bonnet,boot,objective);
		}
	}

	if(newkeys & KEY_YES)
	{
	    if(PlayerData[playerid][char_stage] == STAGE_ZONE_SET_X)
	    {
	        new uid = FreeID[playerid], Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	    	Zone[uid][z_min][0] = X;
	    	Zone[uid][z_min][1] = Y;

	    	new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_minx` = %f, `z_miny` = %f WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_min][0], Zone[uid][z_min][1], uid);
			mysql_query(DB_Query);

	    	PlayerData[playerid][char_stage] = STAGE_ZONE_SET_Y;

	    	new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Teraz idz do punktu ~w~North East ~y~i kliknij ~w~Y ~y~aby zaznaczyc pozycje.", Zone[uid][z_name], Zone[uid][z_uid]);
			InfoTD(playerid, str);

	    	Tip(playerid, "Pozycja zosta³a zapisana.");
		}
		else if(PlayerData[playerid][char_stage] == STAGE_ZONE_SET_Y)
		{
		    new uid = FreeID[playerid], Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);
	        Zone[uid][z_max][0] = X;
	        Zone[uid][z_max][1] = Y;

	        new DB_Query[128];
	    	format(DB_Query, sizeof(DB_Query), "UPDATE `rp_zones` SET `z_maxx` = %f, `z_maxy` = %f WHERE `z_uid` = %d LIMIT 1", Zone[uid][z_max][0], Zone[uid][z_max][1], uid);
			mysql_query(DB_Query);

	        PlayerData[playerid][char_stage] = STAGE_ZONE_SAVE;

	        new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Aby zapisac strefe kliknij ~w~H~y~.", Zone[uid][z_name], Zone[uid][z_uid]);
			InfoTD(playerid, str);

			PlayerData[playerid][char_info_timer] = 8;

	        Tip(playerid, "Pozycja zosta³a zapisana.");
		}

		if(GetNearestObject(playerid, 3.0) != -1)
		{
		    if(PlayerData[playerid][char_bw] != 0)
			{
				Info(playerid, "Nie mo¿esz teraz skorzystaæ z tej komendy.");
				return 1;
			}
			new objectid = GetNearestObject(playerid, 3.0);
			new uid = GetObjectUID(objectid);
			if(Object[uid][object_model] == 2942 || Object[uid][object_model] == 2754)
			{
			    new StrinG[500];
				format(StrinG, sizeof(StrinG), "{CCCCCC}Stan konta {FFFFFF}({00FF00}${FFFFFF}%d)\n{CCCCCC}Wp³aæ gotówkê\n{CCCCCC}Wyp³aæ gotówkê\n{CCCCCC}Wykonaj przelew na konto\n{CCCCCC}Sp³aæ nale¿noœci {FFFFFF}({00FF00}${FFFFFF}%d)", PlayerData[playerid][char_bank], PlayerData[playerid][char_debt]);
			    ShowPlayerDialog(playerid, D_BANK, DIALOG_STYLE_LIST, "Bankomat", StrinG, "Wybierz", "Anuluj");
			}
		}
	}

	if(newkeys & KEY_CTRL_BACK)
	{
	    if(PlayerData[playerid][char_stage] == STAGE_ZONE_SAVE)
	    {
	        new uid = FreeID[playerid];
	        PlayerData[playerid][char_stage] = STAGE_ZONE_NONE;
	        FreeID[playerid] = -1;

	        Zone[uid][z_sampid] = GangZoneCreate(Zone[uid][z_min][0], Zone[uid][z_min][1], Zone[uid][z_max][0], Zone[uid][z_max][1]);

            new str[128];
			format(str, sizeof(str), "~y~Strefa ~w~%s ~y~UID: ~w~%d~n~~y~Strefa zostala zapisana.~n~~n~~y~SampID: ~w~%d", Zone[uid][z_name], Zone[uid][z_uid], Zone[uid][z_sampid]);
			InfoTD(playerid, str);

			PlayerData[playerid][char_info_timer] = 8;

	        Tip(playerid, "Strefa zosta³a zapisana w bazie danych.");
		}
	}

	if(HOLDING(KEY_WALK | KEY_SPRINT))
	{
	    new i = GetNearestDoors(playerid, 2.0);

	    if(GetPlayerVirtualWorld(playerid) == Doors[i][EnterVW])
	    {
	        if(Doors[i][Locked]) return GameTextForPlayer(playerid, "~r~DRZWI ZAMKNIETE!", 5000, 4);

	    	SetPlayerPos(playerid, Doors[i][ExitX], Doors[i][ExitY], Doors[i][ExitZ]);
	    	SetPlayerFacingAngle(playerid, Doors[i][ExitA]);

	    	SetPlayerVirtualWorld(playerid, Doors[i][ExitVW]);
	    	SetPlayerInterior(playerid, Doors[i][ExitInterior]);

	    	PlayerData[playerid][char_inside_doors] = i;
		}
		else if(GetPlayerVirtualWorld(playerid) == Doors[i][ExitVW])
		{
		    if(Doors[i][Locked]) return GameTextForPlayer(playerid, "~r~DRZWI ZAMKNIETE!", 5000, 4);

		    SetPlayerPos(playerid, Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ]);
		    SetPlayerFacingAngle(playerid, Doors[i][EnterA]);

		    SetPlayerVirtualWorld(playerid, Doors[i][EnterVW]);
		    SetPlayerInterior(playerid, Doors[i][EnterInterior]);

			PlayerData[playerid][char_inside_doors] = 0;
		}
	}
	return 1;
}

CMD:stats(playerid, cmdtext[])
{
	new id;
	if(sscanf(cmdtext, "i", id))
	{
	    ShowPlayerStats(playerid, playerid);
	}
	else
	{
		if(!IsPlayerAdmin(playerid) && PlayerData[playerid][char_admin_level] < 3) return ShowPlayerStats(playerid, playerid);
    	if(!IsPlayerConnected(id) || !PlayerData[id][char_logged]) return Tip(playerid, "Ten gracz nie jest po³¹czony.");

		ShowPlayerStats(playerid, id);
	}
	return 1;
}

stock ShowPlayerStats(playerid, id)
{
	new ip[32];
	GetPlayerIp(id, ip, sizeof(ip));

    new str[128];
	format(str, sizeof(str), "%s (ID:%d) (GUID: %d) (UID:%d) (IP:%s)", PlayerData[id][char_name], id, PlayerData[id][char_guid], PlayerData[id][char_uid], ip);

	new online_hours, online_minutes;
	online_hours = (PlayerData[id][char_online] / 3600);
	online_minutes = ((PlayerData[id][char_online] - (PlayerData[id][char_online] / 3600) * 3600) / 60);

	new Float:Health;
	GetPlayerHealth(id, Health);

	new uid = GetPlayerZone(id), zname[32];
	if(GetPlayerZone(id) != -1)
	{
		format(zname, sizeof(zname), "%s", Zone[uid][z_name]);
	}
	else
	{
	    format(zname, sizeof(zname), "---");
	    uid = 0;
	}
	
	new premtime[64];
	if(PlayerData[id][char_premium] > gettime())
	{
	    new year, month, day, hour, minute, second;
		TimestampToDate(PlayerData[id][char_premium], year, month, day, hour, minute, second, 1);
		format(premtime, sizeof(premtime), "%d/%02d/%d %d:%02d:%02d", day, month, year, hour, minute, second);
	}
	else
	{
	    format(premtime, sizeof(premtime), "---");
	}

	if(PlayerData[id][char_inside_doors] != 0)
	{
		new StrinG[2500];
		format(StrinG, sizeof(StrinG), "{CCCCCC}Czas gry:\t{FFFFFF}%dh %02dmin\n{CCCCCC}Energia:\t{FFFFFF}%.0f%%\n{CCCCCC}BW:\t{FFFFFF}%d sek.\n{CCCCCC}Si³a:\t{FFFFFF}%dj\n{CCCCCC}Gotówka:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Bank:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Numer konta:\t{FFFFFF}%d\n{CCCCCC}Drzwi:\t{FFFFFF}%s (UID: %d)\n{CCCCCC}Skin:\t{FFFFFF}%d (domyœlny %d)\n{CCCCCC}Strefa:\t{FFFFFF}%s (UID: %d)\n{FFD700}Premium:\t{FFFFFF}%s",
			online_hours, online_minutes, PlayerData[id][char_health], PlayerData[id][char_bw], PlayerData[id][char_strength], PlayerData[id][char_cash], PlayerData[id][char_bank], PlayerData[id][char_bank_number], Doors[PlayerData[id][char_inside_doors]][Name], PlayerData[id][char_inside_doors], GetPlayerSkin(id), PlayerData[id][char_skin], zname, uid, premtime);
		ShowPlayerDialog(playerid, D_STATS, DIALOG_STYLE_TABLIST, str, StrinG, "Wybierz", "Zamknij");
	}
	else
	{
	    new StrinG[2500];
		format(StrinG, sizeof(StrinG), "{CCCCCC}Czas gry:\t{FFFFFF}%dh %02dmin\n{CCCCCC}Energia:\t{FFFFFF}%.0f%%\n{CCCCCC}BW:\t{FFFFFF}%d sek.\n{CCCCCC}Si³a:\t{FFFFFF}%dj\n{CCCCCC}Gotówka:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Bank:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Numer konta:\t{FFFFFF}%d\n{CCCCCC}Drzwi:\t{FFFFFF}Brak (UID: %d)\n{CCCCCC}Skin:\t{FFFFFF}%d (domyœlny %d)\n{CCCCCC}Strefa:\t{FFFFFF}%s (UID: %d)\n{FFD700}Premium:\t{FFFFFF}%s",
			online_hours, online_minutes, PlayerData[id][char_health], PlayerData[id][char_bw], PlayerData[id][char_strength], PlayerData[id][char_cash], PlayerData[id][char_bank], PlayerData[id][char_bank_number], PlayerData[id][char_inside_doors], GetPlayerSkin(id), PlayerData[id][char_skin], zname, uid, premtime);
		ShowPlayerDialog(playerid, D_STATS, DIALOG_STYLE_TABLIST, str, StrinG, "Wybierz", "Zamknij");
	}
	return 1;
}

stock GetNearestPlayer(playerid, Float:dist)
{
    new targetid = INVALID_PLAYER_ID;
    new Float:x1,Float:y1,Float:z1;
    new Float:x2,Float:y2,Float:z2;
    new Float:tmpdis;
    GetPlayerPos(playerid,x1,y1,z1);
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if(i == playerid) continue;
        GetPlayerPos(i,x2,y2,z2);
        tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
        if(tmpdis < dist)
        {
            dist = tmpdis;
            targetid = i;
        }
    }
    return targetid;
}

stock GetVehicleModelIDFromName(vname[])
{
        for(new i = 0; i < 211; i++)
        {
                if ( strfind(VehicleNames[i], vname, true) != -1 )
                        return i + 400;
        }
        return -1;
}

stock LoadObjectMmat()
{
    new DB_Query[1000], data[1000], loadedo = 0, loadedt = 0, uid, i;
    format(DB_Query, sizeof(DB_Query), "SELECT * FROM `rp_object_mmat`");
    mysql_query(DB_Query);

	mysql_store_result();

	while(mysql_fetch_row_format(data, "|"))
	{
		    sscanf(data, "p<|>ddd", uid, Object[uid][object_mmat_type], i);

			sscanf(data, "p<|>ddddddddddds[32]s[64]s[32]s[64]", Object[uid][object_mmat_uid], Object[uid][object_mmat_type], Object[uid][object_mmat_index][i], Object[uid][object_mmat_color],
				Object[uid][object_mmat_modelid], Object[uid][object_mmat_size], Object[uid][object_mmat_fontsize], Object[uid][object_mmat_fontcolor],
					Object[uid][object_mmat_backcolor], Object[uid][object_mmat_bold], Object[uid][object_mmat_align], Object[uid][object_mmat_font], Object[uid][object_mmat_text],
				 		Object[uid][object_mmat_txdname], Object[uid][object_mmat_texturename]);

			if(Object[uid][object_mmat_type] == 0)
  	      	{
				SetDynamicObjectMaterial(Object[uid][object_sampid], Object[uid][object_mmat_index][i], Object[uid][object_mmat_modelid], Object[uid][object_mmat_txdname], Object[uid][object_mmat_texturename], Object[uid][object_mmat_color]);

                loadedo++;
			}
			else if(Object[uid][object_mmat_type] == 1)
			{
				SetDynamicObjectMaterialText(Object[uid][object_sampid], Object[uid][object_mmat_index][i], Object[uid][object_mmat_text], Object[uid][object_mmat_size], Object[uid][object_mmat_font], Object[uid][object_mmat_fontsize], Object[uid][object_mmat_bold], Object[uid][object_mmat_fontcolor], Object[uid][object_mmat_backcolor], Object[uid][object_mmat_align]);

				loadedt++;
			}
	}

 	mysql_free_result();

	printf("[load][mmat] Za³adowano %d tekstur i %d tekstów na obiekcie.", loadedo, loadedt);
	return 1;
}

stock GetNearestVehicle(playerid, Float:distance)
{
	new
		Float:xX,
		Float:yY,
		Float:zZ,
		retElement = -1
	;
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        GetVehiclePos(i, xX, yY, zZ);
        new Float:odist = GetPlayerDistanceFromPoint(playerid, xX, yY, zZ);
		if (odist < distance)
        {
            retElement = i;
            distance = odist;
        }
    }
    return retElement;
}

stock GetNearestObject(playerid, Float:distance)
{
	new
		Float:xX,
		Float:yY,
		Float:zZ,
		retElement = -1
	;
    for(new i = 0; i < MAX_OBJECTS; i++)
    {
        GetDynamicObjectPos(i, xX, yY, zZ);
        new Float:odist = GetPlayerDistanceFromPoint(playerid, xX, yY, zZ);
		if (odist < distance)
        {
            retElement = i;
            distance = odist;
        }
    }
    return retElement;
}
