forward GivePlayerHealth(playerid, Float:health);
public GivePlayerHealth(playerid, Float:health)
{
	PlayerData[playerid][char_health] += health;
	SetPlayerHealth(playerid, PlayerData[playerid][char_health]);
	return 1;
}
