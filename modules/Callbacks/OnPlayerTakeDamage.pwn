public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(issuerid == INVALID_PLAYER_ID)
	{
	    PlayerData[playerid][char_last_damaged_weapon] = -1;
    	GivePlayerHealth(playerid, -amount);

		new str[128];
		format(str, sizeof(str), "%s lost HP by falling (ping: %d) HP: %.1f", PlayerData[playerid][char_name], GetPlayerPing(playerid), PlayerData[playerid][char_health]);
		Log("dmg", str);
	}
	return 1;
}
