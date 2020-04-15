stock InfoVehicle(playerid, text[])
{
	TextDrawHideForPlayer(playerid, VehicleInfo[playerid]);
	TextDrawSetString(VehicleInfo[playerid], text);
	TextDrawShowForPlayer(playerid, VehicleInfo[playerid]);
	return 1;
}
