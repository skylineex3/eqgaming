stock InfoTD(playerid, text[])
{
	TextDrawHideForPlayer(playerid, PlayerData[playerid][char_info]);
	TextDrawSetString(PlayerData[playerid][char_info], text);
	TextDrawShowForPlayer(playerid, PlayerData[playerid][char_info]);
	return 1;
}
