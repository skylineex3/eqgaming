stock GetNearestDoors(playerid, Float:distance = 5.0)
{
	new doorid = -1;
	for(new i=1; i<MAX_DOORS; i++)
	{
 		if(IsPlayerInRangeOfPoint(playerid, distance, Doors[i][EnterX], Doors[i][EnterY], Doors[i][EnterZ]) || IsPlayerInRangeOfPoint(playerid, distance, Doors[i][ExitX], Doors[i][ExitY], Doors[i][ExitZ]))
   		{
     		doorid = i;
       		break;
		}
	}
	return doorid;
}
