public OnPlayerSpawn(playerid)
{
	if(PlayerData[playerid][char_last_pos][0] > 0.0)
	{
	    SetPlayerPos(playerid, PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2]);
	    SetPlayerFacingAngle(playerid, PlayerData[playerid][char_last_pos][3]);
	    SetCameraBehindPlayer(playerid);
	}
	else
	{
		SetPlayerPos(playerid, 838.2526,-1346.3013,7.1787);
		SetPlayerFacingAngle(playerid, 321.9926);
		SetCameraBehindPlayer(playerid);
	}

	SetPlayerHealthEx(playerid, PlayerData[playerid][char_health]);
	return 1;
}
