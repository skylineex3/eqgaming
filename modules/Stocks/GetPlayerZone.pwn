stock GetPlayerZone(playerid)
{
	new zone = -1;
	for(new i=0; i<MAX_ZONES; i++)
	{
	    if(IsPlayerInArea(playerid, Zone[i][z_min][0], Zone[i][z_min][1], Zone[i][z_max][0], Zone[i][z_max][1]))
	    {
	        zone = i;
	        break;
		}
	}
	return zone;
}
