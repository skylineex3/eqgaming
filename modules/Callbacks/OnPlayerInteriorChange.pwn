public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	for(new i=0; i<GetMaxPlayers(); i++)
	    if(IsPlayerConnected(i))
	        if(PlayerData[i][char_spectate_id] == playerid && GetPlayerState(i) == PLAYER_STATE_SPECTATING)
	            SetPlayerInterior(i, newinteriorid);
	return 1;
}
