stock PlayerName(playerid)
{
	new name[24];
	GetPlayerName(playerid, name, sizeof(name));
	strreplace(name, "_", " ");
	return name;
}
