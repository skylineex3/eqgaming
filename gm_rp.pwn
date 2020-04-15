/*

Projekt: Forgame
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

#include "modules/Callbacks/OnGameModeInit.pwn"
#include "modules/Callbacks/OnGameModeExit.pwn"
#include "modules/Callbacks/OnPlayerConnect.pwn"
#include "modules/Callbacks/OnPlayerDisconnect.pwn"
#include "modules/Callbacks/OnPlayerRequestClass.pwn"
#include "modules/Callbacks/OnDialogResponse.pwn"
#include "modules/Callbacks/OnPlayerSpawn.pwn"
#include "modules/Callbacks/OnPlayerKeyStateChange.pwn"
#include "modules/Callbacks/OnPlayerPickUpDynamicPickup.pwn"
#include "modules/Callbacks/OnPlayerInteriorChange.pwn"
#include "modules/Callbacks/OnPlayerText.pwn"
#include "modules/Callbacks/OnPlayerUpdate.pwn"
#include "modules/Callbacks/OnPlayerEnterVehicle.pwn"
#include "modules/Callbacks/OnPlayerExitVehicle.pwn"
#include "modules/Callbacks/OnPlayerStateChange.pwn"
#include "modules/Callbacks/OnPlayerCommandPerformed.pwn"
#include "modules/Callbacks/OnPlayerDeath.pwn"
#include "modules/Callbacks/OnPlayerClickMap.pwn"
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

main()
{
	//...
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

	printf("[load][mmat] Za�adowano %d tekstur i %d tekst�w na obiekcie.", loadedo, loadedt);
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
    for(new i = 1; i < MAX_VEHICLES; i++)
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
