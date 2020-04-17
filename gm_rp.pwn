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

main()
{
	printf("\n# Projekt eQualityGaming RolePlay zaÅ‚adowano. #\n");
}

#include "modules/Callbacks/OnGameModeInit.pwn"
#include "modules/Callbacks/OnGameModeExit.pwn"
#include "modules/Callbacks/OnPlayerConnect.pwn"
#include "modules/Callbacks/OnPlayerDisconnect.pwn"
#include "modules/Callbacks/OnPlayerRequestClass.pwn"
#include "modules/Callbacks/OnDialogResponse.pwn"
#include "modules/Callbacks/OnPlayerSpawn.pwn"
#include "modules/Callbacks/OnPlayerPickUpDynamicPickup.pwn"
#include "modules/Callbacks/OnPlayerInteriorChange.pwn"
#include "modules/Callbacks/OnPlayerUpdate.pwn"
#include "modules/Callbacks/OnPlayerEnterVehicle.pwn"
#include "modules/Callbacks/OnPlayerExitVehicle.pwn"
#include "modules/Callbacks/OnPlayerStateChange.pwn"
#include "modules/Callbacks/OnPlayerCommandPerformed.pwn"
#include "modules/Callbacks/OnPlayerDeath.pwn"
#include "modules/Callbacks/OnVehicleDamageStatusUpdate.pwn"
#include "modules/Callbacks/OnPlayerGiveDamage.pwn"
#include "modules/Callbacks/OnPlayerTakeDamage.pwn"
#include "modules/Callbacks/OnPlayerSelectDynamicObject.pwn"

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
#include "modules/Stocks/ShowPlayerStats.pwn"
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
		cmd_me(playerid, "robi pyt¹jac¹ minê.");
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

	printf("[load][mmat] Zaï¿½adowano %d tekstur i %d tekstï¿½w na obiekcie.", loadedo, loadedt);
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
