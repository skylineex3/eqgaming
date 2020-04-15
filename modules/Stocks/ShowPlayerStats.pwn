stock ShowPlayerStats(playerid, id)
{
	new ip[32];
	GetPlayerIp(id, ip, sizeof(ip));

    new str[128];
	format(str, sizeof(str), "%s (ID:%d) (GUID: %d) (UID:%d) (IP:%s)", PlayerData[id][char_name], id, PlayerData[id][char_guid], PlayerData[id][char_uid], ip);

	new online_hours, online_minutes;
	online_hours = (PlayerData[id][char_online] / 3600);
	online_minutes = ((PlayerData[id][char_online] - (PlayerData[id][char_online] / 3600) * 3600) / 60);

	new Float:Health;
	GetPlayerHealth(id, Health);

	new uid = GetPlayerZone(id), zname[32];
	if(GetPlayerZone(id) != 0)
	{
		format(zname, sizeof(zname), "%s", Zone[uid][z_name]);
	}
	else
	{
	    format(zname, sizeof(zname), "---");
	    uid = 0;
	}

	new premtime[64];
	if(PlayerData[id][char_premium] > gettime())
	{
	    new year, month, day, hour, minute, second;
		TimestampToDate(PlayerData[id][char_premium], year, month, day, hour, minute, second, 1);
		format(premtime, sizeof(premtime), "%d/%02d/%d %d:%02d:%02d", day, month, year, hour, minute, second);
	}
	else
	{
	    format(premtime, sizeof(premtime), "---");
	}

	if(PlayerData[id][char_inside_doors] != 0)
	{
		new StrinG[2500];
		format(StrinG, sizeof(StrinG), "{CCCCCC}Czas gry:\t{FFFFFF}%dh %02dmin\n{CCCCCC}Energia:\t{FFFFFF}%.0f%%\n{CCCCCC}BW:\t{FFFFFF}%d sek.\n{CCCCCC}Si³a:\t{FFFFFF}%dj\n{CCCCCC}Gotówka:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Bank:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Numer konta:\t{FFFFFF}%d\n{CCCCCC}Drzwi:\t{FFFFFF}%s (UID: %d)\n{CCCCCC}Skin:\t{FFFFFF}%d (domyœlny %d)\n{CCCCCC}Strefa:\t{FFFFFF}%s (UID: %d)\n{FFD700}Premium:\t{FFFFFF}%s",
			online_hours, online_minutes, PlayerData[id][char_health], PlayerData[id][char_bw], PlayerData[id][char_strength], PlayerData[id][char_cash], PlayerData[id][char_bank], PlayerData[id][char_bank_number], Doors[PlayerData[id][char_inside_doors]][Name], PlayerData[id][char_inside_doors], GetPlayerSkin(id), PlayerData[id][char_skin], zname, uid, premtime);
		ShowPlayerDialog(playerid, D_STATS, DIALOG_STYLE_TABLIST, str, StrinG, "Wybierz", "Zamknij");
	}
	else
	{
	    new StrinG[2500];
		format(StrinG, sizeof(StrinG), "{CCCCCC}Czas gry:\t{FFFFFF}%dh %02dmin\n{CCCCCC}Energia:\t{FFFFFF}%.0f%%\n{CCCCCC}BW:\t{FFFFFF}%d sek.\n{CCCCCC}Si³a:\t{FFFFFF}%dj\n{CCCCCC}Gotówka:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Bank:\t{00FF00}${FFFFFF}%d\n{CCCCCC}Numer konta:\t{FFFFFF}%d\n{CCCCCC}Drzwi:\t{FFFFFF}Brak (UID: %d)\n{CCCCCC}Skin:\t{FFFFFF}%d (domyœlny %d)\n{CCCCCC}Strefa:\t{FFFFFF}%s (UID: %d)\n{FFD700}Premium:\t{FFFFFF}%s",
			online_hours, online_minutes, PlayerData[id][char_health], PlayerData[id][char_bw], PlayerData[id][char_strength], PlayerData[id][char_cash], PlayerData[id][char_bank], PlayerData[id][char_bank_number], PlayerData[id][char_inside_doors], GetPlayerSkin(id), PlayerData[id][char_skin], zname, uid, premtime);
		ShowPlayerDialog(playerid, D_STATS, DIALOG_STYLE_TABLIST, str, StrinG, "Wybierz", "Zamknij");
	}
	return 1;
}
