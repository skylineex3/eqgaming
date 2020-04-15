stock TryLogin(playerid)
{
    ClearPlayerData(playerid);

	TogglePlayerSpectating(playerid, true);
	TogglePlayerControllable(playerid, false);

    SetPlayerCameraPos(playerid, 	1088.2151,-1303.5963,84.0296);
  	SetPlayerCameraLookAt(playerid, 986.8760,-1337.6307,21.6103);

    new hour, minute, second;
	gettime(hour, minute, second);
	SetPlayerTime(playerid, hour, minute);

	InterpolateCameraPos(playerid, 1088.2151,-1303.5963,84.0296, 986.8760,-1337.6307,21.6103, 90000*5, CAMERA_MOVE);

    new name[24];
	format(name, sizeof(name), "%s", PlayerName(playerid));
	strreplace(name, " ", "_");
 	SetPlayerName(playerid, name);

    new DB_Query[128];
	format(DB_Query, sizeof(DB_Query), "SELECT `global_id` FROM `rp_chars` WHERE `char_name` = '%s' LIMIT 1", name);
	mysql_query(DB_Query);

	mysql_store_result();

	if(mysql_num_rows() != 0)
	{
		PlayerData[playerid][char_guid] = mysql_fetch_int();
		ShowLoginDialog(playerid, 1);
	}
	else
	{
	    ShowLoginDialog(playerid, 2);
	}

	mysql_free_result();
	return 1;
}
