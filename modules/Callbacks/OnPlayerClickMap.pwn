public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(IsPlayerAdmin(playerid) || PlayerData[playerid][char_admin_level] > 0)
		SetPlayerPosFindZ(playerid, fX, fY, fZ);
    return 1;
}
