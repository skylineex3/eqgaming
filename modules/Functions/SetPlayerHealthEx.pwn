forward SetPlayerHealthEx(playerid, Float:health);
public SetPlayerHealthEx(playerid, Float:health)
{
	PlayerData[playerid][char_health] = health;
	SetPlayerHealth(playerid, PlayerData[playerid][char_health]);
	return 1;
}
