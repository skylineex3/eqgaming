stock GetLowestID(playerid)
{
	new id = INVALID_PLAYER_ID;
	for(new i=0; i<GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i) && i != playerid)
	    {
	        id = i;
			break;
		}
	}
	return id;
}
