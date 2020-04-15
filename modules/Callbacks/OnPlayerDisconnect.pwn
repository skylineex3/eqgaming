public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerData[playerid][char_logged])
	{
		SaveCharacter(playerid);
		SaveItem(playerid);
	}

	TextDrawHideForPlayer(playerid, LSNews[0]);
	TextDrawHideForPlayer(playerid, LSNews[1]);
	TextDrawHideForPlayer(playerid, ForGame);
	return 1;
}
