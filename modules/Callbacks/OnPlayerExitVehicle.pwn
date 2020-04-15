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
