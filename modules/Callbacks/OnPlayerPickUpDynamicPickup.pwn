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
