public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid, 255, PlayerData[playerid][char_skin], PlayerData[playerid][char_last_pos][0], PlayerData[playerid][char_last_pos][1], PlayerData[playerid][char_last_pos][2], PlayerData[playerid][char_last_pos][3], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}
