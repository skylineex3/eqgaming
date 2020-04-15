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
